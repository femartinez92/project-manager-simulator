class ProjectsController < ApplicationController
  before_action :set_project, only: [:show, :edit, :update, :destroy, :costs, :create_requirement, :edit_budget, :configure_simulator, :execute_step]
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
    sum = 0
    @estimated_payment_schedule = @cost_payment_plan.estimated_payment_schedule(@project).sort{|x,y| x[0] <=> y[0]}.map { |x,y| { x => (sum += y)} }.reduce({}, :merge)
    sum = 0
    @real_payment_schedule = @cost_payment_plan.real_payment_schedule(@project).sort{|x,y| x[0] <=> y[0]}.map { |x,y| { x => (sum += y)} }.reduce({}, :merge)
    @stakeholders = @project.stakeholders
    @milestones = @project.milestones
    @budget = @project.budget
    @budget_data = @budget.data_for_stacked_column
    if @project.simulator.nil?
      @project.simulator = Simulator.create!
      @project.save
    end
    @tasks_timeline_data = @project.tasks_for_timeline
    @simulator = @project.simulator
    @can_start_simulation = @simulator.can_start?
  end

  def clone
    original_project = Project.find(params[:id])
    @project = original_project.dup
    @project.save
    @project.clone_characteristics_from(original_project, current_project_manager)
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
    simulator = Simulator.create!
    @project.cost_payment_plan = cpp
    @project.budget = budget
    @project.simulator = simulator
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

  def edit_budget
    b = @project.budget
    b.update(budget_params)
    b.profit = ((b.activities_cost + b.activities_reserve + b.contingency_reserve + b.managment_reserve) * 0.2).to_i
    respond_to do |format|
      if b.save
        format.html { redirect_to @project, notice: 'Presupuesto actualizado' }
        format.json { render :show, status: :ok, location: @project }
      else
        format.html { redirect_to @project, notice: 'Ocurrio un problema al cambiar el presupuesto' }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end

  end

   # GET /projects/1/costs (show project costs)
  def costs
    @cost_payment_plan = @project.cost_payment_plan
    @budget = @project.budget
  end

  def insert_real_cost
    @cost_line = CostLine.find(params[:cost_line_id])
  end

  def save_real_cost
    @project = Project.find(params[:project_id])
    @cost_line = CostLine.find(params[:cost_line_id])
    respond_to do |format|
      if @cost_line.pay( params[:real_amount], params[:real_payment_week])
        format.html { redirect_to project_costs_path(@project), notice: 'Costo pagado satisfactoriamente' }
      else
        format.html { redirect_to insert_real_cost_path(@project), notice: 'Something interrupted the operation, please try again'}
      end
    end
  end

  # ---- SCOPE STATEMENT ---- #

  # GET /
  # We select the project of the project type assigned to this manager
  # In case he don't have one assigned we set this as the first admin project.

  def scope_statement
    unless @admin
      project_id = current_project_manager.project_type_id
      if ( project_id == 0 or project_id == nil)
        if ( Project.from_admin.first != nil)
          current_project_manager.project_type_id = Project.from_admin.first.id
          project_id = current_project_manager.project_type_id
        else
          respond_to do |format|
            format.html { redirect_to projects_path }
          end
          return
        end
      end
      @project = Project.find(project_id)
    else
      respond_to do |format|
        format.html { redirect_to projects_path }
      end
    end
  end

  # ---- Requirements ---- #

  def create_requirement
    req = Requirement.new(requirement_params)
    req.project_id = params[:id]
    respond_to do |format|
      if req.save
        format.html { redirect_to project_path(@project), notice: 'Requisito agregado correctamente' }
      else
        format.html { redirect_to project_path(@project), notice: 'Ocurrió un problema al tratar de guardar el requisito' }
      end
    end
  end

  def edit_requirement
    @project = Project.find(params[:project_id])
    req = Requirement.find(params[:id])
    respond_to do |format|
      if req.update(requirement_params)
        format.html { redirect_to project_path(@project), notice: 'Requisito agregado correctamente' }
      else
        format.html { redirect_to project_path(@project), notice: 'Ocurrió un problema al tratar de guardar el requisito' }
      end
    end
  end

  # ---- SIMULATOR ---- #
  def configure_simulator
    respond_to do |format|
      if @project.simulator.update(simulator_params)
        format.html { redirect_to project_path(@project), notice: 'Requisito agregado correctamente' }
      else
        format.html { redirect_to project_path(@project), notice: 'Ocurrió un problema al tratar de guardar el requisito' }
      end
    end
  end

  def execute_step
    @project.simulator.execute_step
    respond_to do |format|
      format.html { redirect_to project_path(@project), notice: 'Etapa simuada' }
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
      params.require(:project).permit(:name, :actual_week, :start_date, :strategic_objective)
    end

    def requirement_params
      params.permit(:requirement_id, :name, :description, :is_present)
    end

    def budget_params
      params.permit(:activities_cost, :activities_reserve, :contingency_reserve, :managment_reserve)
    end

    def simulator_params
      params.permit(:risk_activation_prob, :resource_unavailable_prob, :scope_modify_prob, :plan_change_prob, :step_length)
    end

end
