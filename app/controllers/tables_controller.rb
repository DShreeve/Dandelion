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
