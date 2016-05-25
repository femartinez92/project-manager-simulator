class TasksController < ApplicationController
  before_action :set_task, only: [:show, :edit, :update, :destroy]
  before_action :set_project, :set_admin
  before_action :set_milestone, except: [:clone]
  before_action :authenticate_project_manager!
  # GET /tasks
  # GET /tasks.json
  def index
    @tasks = @milestone.tasks
  end


  # GET /tasks/1
  # GET /tasks/1.json
  def show
    @costs_list = @task.cost_lines
  end

  # GET /tasks/new
  def new
    @task = Task.new
    # Under which milestone the activity would take place
    miles = [["", 0]]
    Milestone.pluck(:name, :id).each do |milestone|
      miles << milestone
    end
    @milestones = miles
  end

  # GET /tasks/1/edit
  def edit
  end

  # Allows a project manager to add tasks from
  def clone
    @milestone = Milestone.find(params[:id])
    ids = params[:task_ids]
    ids.each do |id|
      task = Task.find(id).dup
      task.milestone_id = params[:id]
      task.is_admin_task = @admin
      task.save
    end
    respond_to do |format|
      format.html { redirect_to project_milestone_path(@project, @milestone), notice: 'Tareas agregadas correctamente' }
    end
  end

  # POST /tasks
  # POST /tasks.json
  def create
    @task = Task.new(task_params)
    @task.milestone_id = params[:milestone_id]
    @task.is_admin_task = @admin
    respond_to do |format|
      if @task.save
        format.html { redirect_to project_milestone_path(@project, @milestone), notice: 'Task was successfully created.' }
        format.json { render :show, status: :created, location: @task }
      else
        format.html { render :new }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tasks/1
  # PATCH/PUT /tasks/1.json
  def update
    respond_to do |format|
      if @task.update(task_params)
        format.html { redirect_to project_milestone_path(@project, @milestone), notice: 'Task was successfully updated.' }
        format.json { render :show, status: :ok, location: @task }
      else
        format.html { render :edit }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tasks/1
  # DELETE /tasks/1.json
  def destroy
    @task.destroy
    respond_to do |format|
      format.html { redirect_to project_milestone_path(@project, @milestone), notice: 'Task was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  #### ----------- Cost lines methods ----------- ####

  # GET /tasks/1/add_cost_line
  def add_cost_line
    @task = Task.find(params[:task_id])
    @cost_line = CostLine.new
  end

  # POST 
  def create_cost_line
    @task = Task.find(params[:task_id])
    @cost_line = CostLine.new(cost_line_params)
    @cost_line.task_id = params[:task_id]
    @cost_line.cost_payment_plan_id = @project.cost_payment_plan.id
    @cost_line.status = 'Pendiente'
    respond_to do |format|
      if @cost_line.save
        format.html { redirect_to project_milestone_task_path(@project, @milestone, @task), notice: 'Cost was successfully created.' }
        format.json { render :show, status: :created, location: @cost_line }
      else
        format.html { render :add_cost_line }
        format.json { render json: @cost_line.errors, status: :unprocessable_entity }
      end
    end
  end

  #### ----------- Private methods ----------- ####

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_task
    @task = Task.find(params[:id])
  end

  def set_milestone
    @milestone = Milestone.find(params[:milestone_id])
  end

  def set_project
    @project = Project.find(params[:project_id])
  end

  def set_admin
    @admin = current_project_manager.has_role? :admin
  end

  # Never trust parameters from the scary internet, 
  # only allow the white list through.
  def task_params
    params.require(:task).permit(:name, :description, :min_duration, :most_probable_duration, :max_duration, :pm_duration_estimation, :milestone_id, :fake, :admin_duration_estimation)
  end

  def cost_line_params
    params.require(:cost_line).permit(:name, :description, :amount, :payment_week, :funding_source)
  end

end
