class PropertyAssignmentsController < ApplicationController
  before_action :set_property_assignment, only: [:show, :edit, :update, :destroy]

  # GET /property_assignments
  # GET /property_assignments.json
  def index
    @property_assignments = PropertyAssignment.all
  end

  # GET /property_assignments/1
  # GET /property_assignments/1.json
  def show
  end

  # GET /property_assignments/new
  def new
    @property_assignment = PropertyAssignment.new
  end

  # GET /property_assignments/1/edit
  def edit
  end

  # POST /property_assignments
  # POST /property_assignments.json
  def create
    @property_assignment = PropertyAssignment.new(property_assignment_params)

    respond_to do |format|
      if @property_assignment.save
        format.html { redirect_to @property_assignment, notice: 'Property assignment was successfully created.' }
        format.json { render :show, status: :created, location: @property_assignment }
      else
        format.html { render :new }
        format.json { render json: @property_assignment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /property_assignments/1
  # PATCH/PUT /property_assignments/1.json
  def update
    respond_to do |format|
      if @property_assignment.update(property_assignment_params)
        format.html { redirect_to @property_assignment, notice: 'Property assignment was successfully updated.' }
        format.json { render :show, status: :ok, location: @property_assignment }
      else
        format.html { render :edit }
        format.json { render json: @property_assignment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /property_assignments/1
  # DELETE /property_assignments/1.json
  def destroy
    @property_assignment.destroy
    respond_to do |format|
      format.html { redirect_to property_assignments_url, notice: 'Property assignment was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_property_assignment
      @property_assignment = PropertyAssignment.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def property_assignment_params
      params.require(:property_assignment).permit(:field_id, :property_id, :value_id)
    end
end
