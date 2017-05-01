class ValuesController < ApplicationController
  before_action :get_project
  before_action :get_table
  before_action :get_field
  before_action :get_property_assignment
  before_action :set_value, only: [:show, :edit, :update, :destroy]
  before_action :get_value_data_type, only: [ :new, :edit]
  before_action :get_property, only: [ :new, :edit]

  # GET /values
  # GET /values.json
  def index
    @values = @property_assignment.value
  end
  # GET /values/1
  # GET /values/1.json
  def show
  end

  # GET /values/new
  def new
    @value = @property_assignment.build_value
  end

  # GET /values/1/edit
  def edit
  end

  # POST /values
  # POST /values.json
  def create
    @value = @property_assignment.build_value(value_params)
    @value.data_type_id =  DataType.find(@property_assignment.property.value_data_type_id).id
    respond_to do |format|
      if @value.save
        format.html { redirect_to project_table_field_path(@project, @table, @field), notice: 'Value was successfully created.' }
        format.json { render :show, status: :created, location: @value }
      else
        format.html { render :new }
        format.json { render json: @value.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /values/1
  # PATCH/PUT /values/1.json
  def update
    respond_to do |format|
      if @value.update(value_params)
        format.html { redirect_to project_table_field_path(@project, @table, @field), notice: 'Value was successfully updated.' }
        format.json { render :show, status: :ok, location: @value }
      else
        format.html { render :edit }
        format.json { render json: @value.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /values/1
  # DELETE /values/1.json
  def destroy
    @value.destroy
    respond_to do |format|
      format.html { redirect_to project_table_field_path(@project, @table, @field), notice: 'Value was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_value
      @value = @property_assignment.value
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def value_params
      params.require(:value).permit(:value)
      
    end

    def get_project
      @project = Project.find(params[:project_id])
    end

    def get_table
      @table = @project.tables.find(params[:table_id])
    end

    def get_field
      @field = @table.fields.find(params[:field_id])
    end

    def get_property_assignment
      @property_assignment = @field.property_assignments.find(params[:property_assignment_id])
    end

    def get_property
      @property =Property.find(@property_assignment.property_id)
    end
    def get_value_data_type
      @value_data_type = DataType.find(@property_assignment.property.value_data_type_id).name
    end
end
