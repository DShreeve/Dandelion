class ValidationAssignmentsController < ApplicationController
  before_action :get_project
  before_action :get_table
  before_action :get_field
  before_action :set_validation_assignment, only: [:show, :edit, :update, :destroy]
  before_action :get_validations, only: [:new, :edit]

  # GET /validation_assignments
  # GET /validation_assignments.json
  def index
    @validation_assignments = @field.validation_assignments
  end

  # GET /validation_assignments/1
  # GET /validation_assignments/1.json
  def show
  end

  # GET /validation_assignments/new
  def new
    @validation_assignment = @field.validation_assignments.new
  end

  # GET /validation_assignments/1/edit
  def edit
  end

  # POST /validation_assignments
  # POST /validation_assignments.json
  def create
    @validation_assignment = @field.validation_assignments.new(validation_assignment_params)

    respond_to do |format|
      if @validation_assignment.save
        format.html { redirect_to project_table_field_path(@project, @table, @field), notice: 'Validation assignment was successfully created.' }
        format.json { render :show, status: :created, location: @validation_assignment }
      else
        format.html { render :new }
        format.json { render json: @validation_assignment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /validation_assignments/1
  # PATCH/PUT /validation_assignments/1.json
  def update
    respond_to do |format|
      if @validation_assignment.update(validation_assignment_params)
        format.html { redirect_to project_table_field_path(@project, @table, @field), notice: 'Validation assignment was successfully updated.' }
        format.json { render :show, status: :ok, location: @validation_assignment }
      else
        format.html { render :edit }
        format.json { render json: @validation_assignment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /validation_assignments/1
  # DELETE /validation_assignments/1.json
  def destroy
    @validation_assignment.destroy
    respond_to do |format|
      format.html { redirect_to project_table_field_path(@project, @table, @field), notice: 'Validation assignment was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_validation_assignment
      @validation_assignment = @field.validation_assignments.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def validation_assignment_params
      params.require(:validation_assignment).permit( :validation_id)
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

    def get_validations
      @validations = Validation.where(field_data_type_id: @field.data_type_id)
    end
end
