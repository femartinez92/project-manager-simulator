class ProjectsController < ApplicationController
  before_action :set_project, only: [:show, :edit, :update, :destroy, :costs]
  before_action :set_admin
  before_action :authenticate_project_manager!
  # GET /projects
  # GET /projects.json
  def index
    if @admin
      @projects = Project.from_admin
      @cloned_projects = Project.cloned
    else
      @projects = current_project_manager.projects
      @admin_projects = Project.from_admin
    end
  end

  # GET /projects/1
  # GET /projects/1.json
  def show
    @cost_payment_plan = @project.cost_payment_plan
    @cost_lines = @cost_payment_plan.cost_lines
    @stakeholders = @project.stakeholders
    @milestones = @project.milestones
    @budget = @project.budget
  end

  def clone
    @project = Project.find(params[:id]).dup
    cpp = CostPaymentPlan.create!
    budget = Budget.create!
    @project.cost_payment_plan = cpp
    @project.budget = budget
    @project.project_manager_id = current_project_manager.id
    @project.is_admin_project = current_project_manager.has_role? :admin
    @project.status = 'Inicio'
    respond_to do |format|
      if @project.save
        format.html { redirect_to @project, notice: 'Project was successfully created.' }
        format.json { render :show, status: :created, location: @project }
      else
        format.html { render :new }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  # GET /projects/new
  def new
    @project = Project.new
  end

  # GET /projects/1/edit
  def edit
  end

   # POST /projects
  # POST /projects.json
  def create
    @project = Project.new(project_params)
    cpp = CostPaymentPlan.create!
    budget = Budget.create!
    @project.cost_payment_plan = cpp
    @project.budget = budget
    @project.project_manager_id = current_project_manager.id
    @project.is_admin_project = current_project_manager.has_role? :admin
    @project.status = 'Inicio'
    respond_to do |format|
      if @project.save
        format.html { redirect_to @project, notice: 'Project was successfully created.' }
        format.json { render :show, status: :created, location: @project }
      else
        format.html { render :new }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /projects/1
  # PATCH/PUT /projects/1.json
  def update
    respond_to do |format|
      if @project.update(project_params)
        format.html { redirect_to @project, notice: 'Project was successfully updated.' }
        format.json { render :show, status: :ok, location: @project }
      else
        format.html { render :edit }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /projects/1
  # DELETE /projects/1.json
  def destroy
    @project.destroy
    respond_to do |format|
      format.html { redirect_to projects_url, notice: 'Project was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  # ---- Costs ---- #

   # GET /projects/1/costs (show project costs)
  def costs
    @cost_payment_plan = @project.cost_payment_plan
    @budget = @project.budget
  end

  def insert_real_cost
    @cost_line = CostLine.find(params[:cost_line_id])
  end

  def save_real_cost
    set_project
    @cost_line = CostLine.find(params[:cost_line_id])
    @cost_line.real_amount = params[:real_amount]
    @cost_line.real_payment_week = params[:real_payment_week]
    @cost_line.funding_source = params[:funding_source]
    @cost_line.status = 'Pagado';
    respond_to do |format|
      if @cost_line.save
        format.html { redirect_to project_costs_path(@project), notice: 'Costo pagado satisfactoriamente' }
      else
        format.html {redirect_to insert_real_cost_path(@project), notice: 'Something interrupted the operation, please try again'}
      end
    end
  end



  private

    # Use callbacks to share common setup or constraints between actions.
    def set_project
      @project = Project.find(params[:id])
    end

    def set_admin
      if current_project_manager
        @admin = current_project_manager.has_role? :admin
      else
        @admin = false
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def project_params
      params.require(:project).permit(:name, :actual_week)
    end
end
