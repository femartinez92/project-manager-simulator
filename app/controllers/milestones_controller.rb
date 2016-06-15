class MilestonesController < ApplicationController
  before_action :set_milestone, only: [:show, :edit, :update, :destroy]
  before_action :set_project, :set_admin
  before_action :authenticate_project_manager!
  # GET /milestones
  # GET /milestones.json
  def index
    @milestones = @project.milestones
    parent_project = Project.from_admin.where(name: @project.name).first
    @posible_milestones = parent_project.milestones.to_a.keep_if { |mile| @milestones.where(name: mile.name).length == 0 }
  end

  # GET /milestones/1
  # GET /milestones/1.json
  def show
    @tasks = @milestone.tasks
    source_milestone = Milestone.from_admin.where(name: @milestone.name).first
    @posible_tasks = source_milestone.tasks.to_a.keep_if { |task| @tasks.where(name: task.name).length == 0 }
  end

  # Clone milestones
  def clone
    ids = params[:milestone_ids]
    ids.each do |id|
      milestone = Milestone.find(id).dup
      milestone.project_id = params[:project_id]
      milestone.is_admin_milestone = @admin
      milestone.save
    end
    respond_to do |format|
      format.html {redirect_to project_milestones_path(@project), notice: 'Hito agregado correctamente'}
    end
  end

  # GET /milestones/new
  def new
    @milestone = Milestone.new
  end

  # GET /milestones/1/edit
  def edit
  end

  # POST /milestones
  # POST /milestones.json
  def create
    @milestone = Milestone.new(milestone_params)
    @milestone.project_id = params[:project_id]
    @milestone.is_admin_milestone = @admin
    respond_to do |format|
      if @milestone.save
        format.html { redirect_to project_milestones_path, notice: 'Milestone was successfully created.' }
        format.json { render :show, status: :created, location: @milestone }
      else
        format.html { render :new }
        format.json { render json: @milestone.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /milestones/1
  # PATCH/PUT /milestones/1.json
  def update
    respond_to do |format|
      if @milestone.update(milestone_params)
        format.html { redirect_to project_milestones_path, notice: 'Milestone was successfully updated.' }
        format.json { render :show, status: :ok, location: @milestone }
      else
        format.html { render :edit }
        format.json { render json: @milestone.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /milestones/1
  # DELETE /milestones/1.json
  def destroy
    @milestone.destroy
    respond_to do |format|
      format.html { redirect_to project_milestones_url, notice: 'Milestone was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  #### ----------- Precedent methods --------- ####
  
  # GET projects/1/precedents
  def precedent_index
    @tasks ||= []
    @project.milestones.each do |miles|
      miles.tasks.each do |task|
        task.update(start_date: @project.start_date) if task.start_date.nil?
        task.update(end_date: task.start_date + task.pm_duration_estimation.days) if task.end_date.nil?
        @tasks << task
      end
    end
    @precedents = Precedent.where(project_id: @project.id)
  end

  # GET projects/1/precedents/new
  def new_precedent
    @tasks ||= []
    @project.milestones.each do |miles|
      miles.tasks.each do |task|
        @tasks << task
      end
    end
  end

  # POST projects/1/precedents
  def create_precedent
    p params[:predecessor_id]
    predecessor = params[:predecessor_id].first
    dependent_ids = params[:dependent_ids]
    dependent_ids.each do |dependent|
      precedent = Precedent.new(predecessor_id: predecessor, dependent_id: dependent, project_id: @project.id)
      precedent.save
    end
    respond_to do |format|
        format.html { redirect_to precedents_path(@project, @milestone, @task), notice: 'Dependencia creada corretamente' }
        format.json { render :show, status: :created, location: @cost_line }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_milestone
      @milestone = Milestone.find(params[:id])
    end

    def set_project
      @project = Project.find(params[:project_id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def milestone_params
      params.require(:milestone).permit(:name, :description, :due_date, :fake)
    end

    def set_admin
      @admin = current_project_manager.has_role? :admin
    end
end
