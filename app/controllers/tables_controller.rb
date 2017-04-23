class TablesController < ApplicationController
  before_action :get_project
  before_action :set_table, only: [:show, :edit, :update, :destroy]
  
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

  def write_test(id)
    table = Table.find(id)
    fileName = table.name.downcase + "_spec.rb"
    file = File.open( fileName, "w")

    # Introduction/Set-up file
    file.puts "require \"spec_helper\""
    file.puts ""
    file.puts "desrcibe \"" + table.name.titleize + "\" do"
    file.puts ""
    file << factory(table.name)

    #Context loop for each field

    table.fields.each do |f|
      if f.property_assignments.empty?
        next
      else
        file.puts "\tdescribe \"" + f.name + " field has property\" do"
        file.puts ""
        properties = package_properties(p)
        if rules_contain( "blank", properties)
          file << blank_rule(bool)
        end
        if rules_contain( "inclusion", properties )
          #the stuff
          next
        end
        f.property_assignments.each do |p|
          
          file.puts "\t\tcontext \"" + Property.find(p.property_id).name + " " + p.value.value + "\" do"
          file << (property_write(table.name.downcase, f.name,"<@valid>", "<@in_valid>", Property.find(p.property_id).rule,p.value.value))
          file.puts "\t\tend"
          file.puts ""
        end
      end
      file.puts "\tend"
      file.puts ""
    end

    #End

    file.puts "end"
    file.close
  end

  def package_properties(assignments)
    if assignments.empty?
      return []
    else
      rules = []
      assignments.each do |a|
        property = Property.find(a.property_id)
        value = property.value
        dataType = DataType.find(value.data_type_id)
        rules << [property.rule, value.value, dataType]
      end
      return rules
    end
  end

  def rules_contain(rule, rules)
    if rules.empty
      return false
    else
      rules.each do |r|
        if r[0] == rule
          return true
        end
      return false
  end

  def rules_index_of(rule, rules)
    rules.each_with_index do | r , i |
      if r[0] == rule
        return i
      end
  end

  def factory(name)
    tab = "\t"
    intro = tab*1 + "it \"has a valid factory\" do"
    main = tab*2 + "expect(build(:" + name.downcase + ")).to be_valid"
    last = tab*1 + "end"
    return intro + "\n" + main + "\n" +last +"\n\n"
  end

  def property_write(table,field, gen_v, gen_iv, rule, chosen)
    tab = "\t"
    n = "\n"

    valid_intro = tab*3 + "it \"is valid with generated value\" do"
    valid_main_1 = tab*4 + table + " = build(:" + table + "," + field + ": " + gen_v + ")"
    valid_main_2 = tab*4 + "if " + table + ".respond_to?(:valid?)"
    valid_main_3 = tab*5 + "expect(" + table + ").to be_valid, lambda { " + table + ".errors.full_messages.join(\"\\n\") }"
    valid_end = tab*4 + "end" + n + tab*3 + "end"
    valid_whole = valid_intro + n + valid_main_1 + n + valid_main_2 + n + valid_main_3 + n + valid_end + n 

    in_value_intro = tab*3 + "it \"generated a correct invalid value\" do"
    in_value_main = tab*4 + "expect(" + gen_iv +").to_not be " + rule + " " + chosen
    in_value_end = tab*3 + "end"
    in_value_whole = in_value_intro + n + in_value_main + n + in_value_end + n

    in_valid_intro = tab*3 + "it \"is invalid with generated value\" do"
    in_valid_main_1 = tab*4 + table + " = build(:" + table + "," + field + ": " + gen_iv + ")"
    in_valid_main_2 = tab*4 + "if " + table + ".respond_to?(:valid?)"
    in_valid_main_3 = tab*5 + "expect(" + table + ").to_not be_valid, lambda { " + table + ".errors.full_messages.join(\"\\n\") }"
    in_valid_end = tab*4 + "end" + n + tab*3 + "end"
    in_valid_whole = in_valid_intro + n + in_valid_main_1 + n + in_valid_main_2 + n + in_valid_main_3 + n + in_valid_end + n 

    return   valid_whole + in_value_whole + in_valid_whole 
  end


  def generate_value_pair_integer (isolated, rest)

    for full_iteration in 1..50
      numbers = gen_rand_int_array(50000) #inefficent but more readable to replace when exclusion
      if isolated != nil
        if isolated[0] == "exclusion"
          numbers = int_rule_string_value_helper(isolated[1])
        else
          numbers = fail_int_rule(numbers, isolated[0], isolated[1])
        end
        if numbers.empty? #empty exclusion is fucked
          next
        end
      end
      if rest.empty?
        return numbers.sample
      else
        rest.each do |rule|
          numbers = pass_int_rule(numbers, rule[0], rule[1])
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
    end

    return false

  end

  def pass_int_rule( numbers, rule, value)
    if rule == "divisible"
      return numbers.keep_if{ |n| n % value == 0}
    elsif rule == "exclusion"
      excluded = int_rule_string_value_helper(value)
      return numbers.delete_if{ |n| excluded.include?(n)}
    else
      return numbers.keep_if{ |n| n.method(rule).(value)}
    end
  end

  def fail_int_rule( numbers, rule, value)
    if rule == "divisible"
      return numbers.delete_if{ |n| n % value == 0}
    else
      return numbers.delete_if{ |n| n.method(rule).(value)}
    end
  end

  # Converts string value from database to array
  def int_rule_string_value_helper(string)
    return array = string.split(",").map{ |s| s.to_i}
  end

  def contains_inclusion( array)
    if array.empty?
      return false
    elsif array.all? { |e| e.kind_of? Array}
      array.each do |rule|
        if rule[0] == "inclusion"
          return true
        end
      end
      return false
    elsif array[0] == "inclusion"
      return true
    else
      return false
    end
  end

  def gen_rand_int_array(amount)
    array = amount.times.map{ Random.rand(-1000000000 .. 1000000000)}
    return array
  end


  def gen_rand_string(regex, a, b, c)
    return regex.examples(max_repeater_variance: a , max_group_results: b, max_results_limit: c)
  end

  def gen_rand_string2(regex, a, b, c)
    array = []
    for i in 0..5
      array << regex.random_example(max_repeater_variance: a)
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
