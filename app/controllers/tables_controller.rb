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

    #Start
    file.puts "require \"spec_helper\""
    file.puts ""
    file.puts "desrcibe \"" + table.name.titleize + "\" do"
    file.puts ""
    file << factory(table.name)
    #Context loop for each field
    table.fields.each do |f|
      file.puts "\tdescribe \"" + f.name + " field has property\" do"
      file.puts ""
      f.property_assignments.each do |p|
        file.puts "\t\tcontext \"" + Property.find(p.property_id).name + " " + p.value.value + "\" do"
        file << (property_write(table.name.downcase, f.name,"<@valid>", "<@in_valid>", Property.find(p.property_id).rule,p.value.value))
        file.puts "\t\tend"
        file.puts ""
      end

      file.puts "\tend"
      file.puts ""
    end

    #End

    file.puts "end"
    file.close
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

    value_intro = tab*3 + "it \"generated a correct valid value\" do"
    value_main = tab*4 + "expect(" + gen_v +").to be " + rule + " " + chosen
    value_end = tab*3 + "end"
    value_whole = value_intro + n + value_main + n + value_end + n

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

    return value_whole +  valid_whole + in_value_whole + in_valid_whole 
  end


  def generate_value_pair_integer (isolated, rest)

    for full_iteration in 0..50
      numbers = gen_rand_int_array(50000)
      if isolated != nil
        numbers = fail_int_rule(numbers, isolated[0], isolated[1])
        if numbers.empty?
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





  def gen_rand_int_array(amount)
    array = amount.times.map{ Random.rand(-1000000000 .. 1000000000)}
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
