class TablesController < ApplicationController
  before_action :get_project
  before_action :set_table, only: [:show, :edit, :update, :destroy, :generate_tests_for_table]
  
  # GET /tables
  # GET /tables.json
  def index
    @tables = @project.tables
  end

  # GET /tables/1
  # GET /tables/1.json
  def show
  end

  # GET /tables/new
  def new
    @table = @project.tables.new
  end

  # GET /tables/1/edit
  def edit
  end

  # POST /tables
  # POST /tables.json
  def create
    @table = @project.tables.new(table_params)

    respond_to do |format|
      if @table.save
        format.html { redirect_to project_table_path(@project,@table), notice: 'Table was successfully created.' }
        format.json { render :show, status: :created, location: @table }
      else
        format.html { render :new }
        format.json { render json: @table.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tables/1
  # PATCH/PUT /tables/1.json
  def update
    respond_to do |format|
      if @table.update(table_params)
        format.html { redirect_to project_table_path(@project,@table), notice: 'Table was successfully updated.' }
        format.json { render :show, status: :ok, location: @table }
      else
        format.html { render :edit }
        format.json { render json: @table.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tables/1
  # DELETE /tables/1.json
  def destroy
    @table.destroy
    respond_to do |format|
      format.html { redirect_to project_path(@project), notice: 'Table was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  ###########################################################################
  # TablesController.new.generate_tests_for_table(1)
  def generate_tests_for_table(id)

    table = Table.find(id)
    fileName = table.name.downcase + "_spec.rb"
    #file = File.open(fileName, "w")
    file = Tempfile.new(fileName,'tmp')
    # Introduction/Set-up file
    file.puts "require \"spec_helper\""
    file.puts ""
    file.puts "desrcibe \"" + table.name.titleize + "\" do"
    file.puts ""
    file << write_factory_test(table.name, 1)

    #Context loop for each field
    # Hash stores variables to populate test templates
    hash = { tableName: table.name.downcase}
    table.fields.each do |f|
      hash[:fieldName] = f.name
      if f.validation_assignments.empty?
        next 
      else
        file.puts "\tdescribe \"" + f.name + " field has validation\" do"
        file.puts ""
        validations = package_validations(f.validation_assignments)
        if validations_contain?("blank", validations)
          index = validations_index_of("blank", validations)
          if validations[index][1] == "true"
            file << blank_test(hash, true, 2)
          else
            file << blank_test(hash, false, 2)
          end
          # Remove blank from validations, fully handled
          validations.delete_at(index)
          hash.delete(:decision)
          hash.delete(:equator)
        end
        if validations_contain?("inclusion", validations)
          index = validations_index_of("inclusion", validations)
          if DataType.find(f.data_type_id).name == "String"
            stringArray = validations[index][1].split(",").map(&:strip)
            file << string_inclusion(hash, stringArray)
          else
            numberArray = database_string_to_number_array(validations[index][1])
            file << number_inclusion(hash, numberArray)
          end
          next # Inclusion supercedes remaining validations, skip to next
        end
        # test with all validations valid
        file.puts "\t\tit \"is valid with a generated value\" do\n"
        if DataType.find(f.data_type_id).name == "String"          
          value = generate_string_value(nil, validations)
          hash[:generatedValue] = value
          file << test_text(true, hash, 3)
          file.puts ""
        else
          value = 0
          if DataType.find(f.data_type_id).name == "Float"
            value = generate_value_integer(nil, validations, "Float")
          elsif DataType.find(f.data_type_id).name == "Integer"
            value = generate_value_integer(nil, validations, "Integer")
          end
          hash[:generatedValue] = value
          file << test_text(true, hash, 3)
        end
        # Write test isolating each validation to be invalid
        validations.each do |p|
          # Array we can manipulate
          rest = [].replace(validations)
          rest.delete_if{ |e| e == p} # remove isolated rule
          file.puts "\t\tit \"is invalid with a value thats is not " + p[0].to_s + " " + p[1].to_s + "\" do"
          if DataType.find(f.data_type_id).name == "String"
            value = generate_string_value(p, rest)
            hash[:generatedValue] = value
            file << test_text(false, hash, 3)
          else
            value = 0
            if DataType.find(f.data_type_id).name == "Float"
              value = generate_value_integer(p, rest, "Float")
            elsif DataType.find(f.data_type_id).name == "Integer"
              value = generate_value_integer(p, rest, "Integer")
            end
            hash[:generatedValue] = value
            file << test_text(false, hash, 3)
          end
          file.puts "\t\tend"
          file.puts ""
        end
      end
      file.puts "\tend"
      file.puts ""
    end
    file.puts "end"
    file.close
    
    return file.path, fileName
      
    
    #send_file file.path
    #render nothing: true
  end

  def download
    file , name = generate_tests_for_table(params[:id])
    send_file(file, :filename => name ,  type: "text/rb", :disposition => "attachment")
  end
  def package_validations(assignments)
    if assignments.empty?
      return []
    else
      rules = []
      assignments.each do |a|
        validation = Validation.find(a.validation_id)
        value = a.value.value
        rules << [validation.rule, value]
      end
      return rules
    end
  end

  def blank_test(hash, bool, indent)
    tab = "\t" #Add initial indent
    template = tab*indent + "it \"%{decision} be blank\" do \n" +
               tab*(indent+1) + "%{tableName} = build(:%{tableName}, %{fieldName}: nil)\n" +
               tab*(indent+1) + "if %{tableName}.respond_to?(:valid?)\n" +
               tab*(indent+2) + "expect(%{tableName}).%{equator} be_valid, lambda {%{tableName}.errors.full_messages.join(\"\\n\")}\n" +
               tab*(indent+1) + "end\n" +
               tab*indent + "end\n\n"
    if bool
      hash[:decision] = "can"
      hash[:equator] = "to"
    else
      hash[:decision] = "can not"
      hash[:equator] = "to_not"
    end    
    return template % hash
  end
  # GORDON, better to loop after or before check ?
  def number_inclusion(hash, includedValues)
    correctValue = includedValues.sample
    incorrectValue = 0
    if correctValue.is_a? Float
      for i in 1..50
        numbers = gen_rand_float_array
        numbers.delete_if{ |n| includedValues.include?(n) }
        if numbers.empty?
          next
        else
          incorrectValue = numbers.sample
          break
        end
      end
    else
      for i in 1..50
        numbers = gen_rand_int_array
        numbers.delete_if{ |n| includedValues.include?(n) }
        if numbers.empty?
          next
        else
          incorrectValue = numbers.sample
          break
        end
      end
    end
    hash[:generatedValue] = correctValue
    correctTestText = test_text(true,hash,3)
    hash[:generatedValue] = incorrectValue
    inCorrectTestText = test_text(false,hash,3)
    correct_intro = "\t\tit \"is valid with a value from inclusion\" do\n"
    incorrect_intro = "\t\tit \"is invalid with a value not in inclusion\" do\n"
    return correct_intro + correctTestText + incorrect_intro + inCorrectTestText 
  end

  def string_inclusion(hash, includedValues)
    correctValue = prep_string(includedValues.sample)
    incorrectValue = ""
    regexp = [/\A[a-zA-Z]*[a-zA-Z]*\z/, /\A[\w]*[\w]*\z/, /\A[\w]*[[:punct:]]*[\w]*\z/, /\A[\w]*[[:print:]]*[a-zA-Z]*\z/]
    strings = []
    for i in 1..50
      regexp.each do |r|
        strings += gen_rand_string_array(r, (1000/regexp.length))
      end
      strings.delete_if{ |n| includedValues.include?(n) }
      if strings.empty?
        next
      else
        incorrectValue = prep_string(strings.sample)
        break
      end
    end
    hash[:generatedValue] = correctValue
    correctTestText = test_text(true, hash, 3)
    hash[:generatedValue] = incorrectValue
    inCorrectTestText = test_text(false, hash, 3)
    correct_intro = "\t\tit \"is valid with a value from inclusion\" do\n"
    incorrect_intro = "\t\tit \"is invalid with a value not in inclusion\" do\n"
    return correct_intro + correctTestText + incorrect_intro + inCorrectTestText 
  end

  def validations_contain?(rule, rules)
    if rules.empty?
      return false
    else
      rules.each do |r|
        if r[0] == rule
          return true
        end
      end
      return false
    end
  end

  def validations_index_of(rule, rules)
    rules.each_with_index do | r , i |
      if r[0] == rule
        return i
      end
    end
  end

  def write_factory_test(name, indent)
    tab = "\t"
    template = tab*indent + "it \"has a valid factory\" do\n" +
               tab*(indent+1) + "expect(build(:" + name.downcase + ")).to be_valid\n" +
               tab*indent + "end\n\n"
    return template 
  end

  # GORDON - better on one line (3rd line template)
  def test_text(beValid,hash, indent)
    tab = "\t"
    if beValid
      hash[:valid] = "to"
    else
      hash[:valid] = "to_not"
    end
    template = tab*indent + "%{tableName} = build(:%{tableName}, %{fieldName}: %{generatedValue})\n" +
               tab*indent + "if %{tableName}.respond_to?(:valid?)\n" +
               tab*(indent+1) + "expect(%{tableName}).%{valid} be_valid, lambda {%{tableName}.errors.full_messages.join(\"\\n\")}\n" +
               tab*indent + "end\n" 
    return template % hash
  end


  def generate_value_integer (isolated, rest , type)    
    # isolated can be passed as nil to generate a pass all
    # Begin generation loop
    for iteration in 1..50
      numbers = []
      # inefficent when isolated is exculsion, but clearer structure
      # also very minute efficency loss
      if type == "Integer"
        numbers = gen_rand_int_array(50000) 
      else
        numbers = gen_rand_float_array(50000)
      end
      if isolated != nil
        # If testing exclusion then return one of its values 
        if isolated[0] == "exclusion"
          return  database_string_to_number_array(isolated[1]).sample 
        else
          numbers = fail_num_rule(numbers, isolated[0], isolated[1])
          if numbers.empty? 
            next
          end
        end
      end            
      rest.each do |rule|
        numbers = pass_num_rule(numbers, rule[0], rule[1])
        
        if numbers.empty?
          break
        end
      end
      if numbers.empty?
        next
      else
        return numbers.sample
      end
    end
    # No valid value generated
    return "\"!!!ERROR GENERATING VALUE\""
  end

  def prep_string(string)
    # Add speech marks and escape \ " within to be written safely to test file
    return "\"" + string.gsub(/[\"\\]/){ |c| "\\"+c } + "\""
  end

  def generate_string_value(isolated, rest)
    # isolated can be passed as nil to generate a pass all
    # default regexp to generate strings
    regexp = [/\A[a-zA-Z]*[a-zA-Z]*\z/, /\A[\w]*[\w]*\z/, /\A[\w]*[[:punct:]]*[\w]*\z/, 
      /\A[\w]*[[:print:]]*[a-zA-Z]*\z/]
    # Add users regexp to the defaults if in rest
    if !rest.empty?
        if validations_contain?("format", rest)
          index = validations_index_of("format", rest)
          regexp << rest[index][1].to_regexp
        end
    end
    # Begin generation loop
    for full_iteration in 1..50
      strings = []
      # If testing exclusion then return one of its values 
      if (isolated != nil) && (isolated[0] == "exclusion")
        return prep_string(isolated[1].split(",").map(&:strip).sample) 
      else
        regexp.each do |r|
          strings += gen_rand_string_array(r, (1000/regexp.length))
        end
      end
      if isolated != nil
        strings = fail_string_rule(strings, isolated[0], isolated[1])
        if strings.empty?
          next
        end
      end
      rest.each do |rule|
        strings = pass_string_rule(strings, rule[0], rule[1])
        if strings.empty?
          break
        end
      end
      if strings.empty?
        next
      else
        return prep_string(strings.sample)
      end     
    end
    # No valid value generated
    return "\"!!!ERROR GENERATING VALUE\""
  end

  def pass_num_rule( numbers, rule, value)
    if rule == "exclusion"
      excluded = database_string_to_number_array(value)
      return numbers.delete_if{ |n| excluded.include?(n) }
    end
    if numbers[0].is_a? Integer
      value = value.to_i
    else
      value = value.to_f
    end
    if rule == "divisible"
      return numbers.keep_if{ |n| (n % value) == 0}
    else # ASSUMED: Only >,>=,<,<= validations can progress to here
      # Comparorator stored as string in database e.g ">"
      return numbers.keep_if{ |n| n.method(rule).(value) }
    end
  end

  def fail_num_rule( numbers, rule, value)
    if numbers[0].is_a? Integer
      value = value.to_i
    else
      value = value.to_f
    end
    if rule == "divisible"
      return numbers.delete_if{ |n| (n % value) == 0 }
    else # ASSUMED: Only >,>=,<,<= validations can progress to here
      # Comparorator stored as string in database e.g ">"
      return numbers.delete_if{ |n| n.method(rule).(value) }
    end
  end

  def pass_string_rule( strings, rule, value )
    if rule == "regex"
      regex = value.to_regexp
      return strings.keep_if{ |n| n =~ regex } # =~ , ""[regex] , "".match(regex) #ATTN TIMINGS
    elsif rule == "exclusion"
      excluded = value.split(",").map(&:strip)
      return strings.delete_if{ |n| excluded.include?(n)}
    else # ASSUMED: Only length validations can progress to here
      # Comparorator stored as string in database e.g ">"
      return strings.keep_if{ |n| n.length.method(rule).(value.to_i)}
    end
  end

  def fail_string_rule(strings, rule, value )
    if rule == "regex"
      regex = value.to_regexp
      return strings.delete_if{ |n| n =~ regex }
    else # ASSUMED: Only length validations can progress to here
      # Comparorator stored as string in database e.g ">"
      return strings.delete_if{ |n| n.length.method(rule).(value.to_i)}
    end
  end

  # Converts string of values from database to array
  def database_string_to_number_array(string)
    if string.include? "."
      return string.split(",").map{ |s| s.to_f } #Float
    else
      return string.split(",").map{ |s| s.to_i } #Integer
    end
  end

  def gen_rand_int_array(amount)
    array = amount.times.map{Random.rand(-1000000 .. 1000000)}
    return array
  end

  def gen_rand_float_array(amount)
    array = amount.times.map{Random.rand(-1000000.0 .. 1000000.0)}
    return array
  end

  def gen_rand_string_array(regex, amount)
    array = []
    # Generate amount specified as generated empty strings are deleted
    while array.length < amount
      string = regex.random_example(max_repeater_variance: 50)
      if string != ""
        array << string
      end
    end
    return array
  end

  ###########################################################################

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_table
      @table = @project.tables.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def table_params
      params.require(:table).permit(:name, :description)
    end

    def get_project
      @project = Project.find(params[:project_id])
    end

end
