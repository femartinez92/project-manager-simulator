class StakeholdersController < ApplicationController
  before_action :set_stakeholder, only: [:show, :edit, :update, :destroy, :increase_commitment]
  before_action :set_project, :set_admin
  before_action :authenticate_project_manager!
  # GET projects/1/stakeholders
  # GET projects/1/stakeholders.json
  def index
    @stakeholders = @project.stakeholders
  end

  # GET projects/1/stakeholders/1
  # GET projects/1/stakeholders/1.json
  def show
  end

  # GET projects/1/stakeholders/new
  def new
    @stakeholder = Stakeholder.new
  end

  # GET projects/1/stakeholders/1/edit
  def edit
  end

  # POST projects/1/stakeholders
  # POST projects/1/stakeholders.json
  def create
    @stakeholder = Stakeholder.new(stakeholder_params)
    @stakeholder.project_id = @project.id
    @stakeholder.is_admin_stakeholder = @admin
    respond_to do |format|
      if @stakeholder.save
        format.html { redirect_to project_stakeholders_path(@project), notice: 'Stakeholder was successfully created.' }
        format.json { render :show, status: :created, location: @stakeholder }
      else
        format.html { render :new }
        format.json { render json: @stakeholder.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT projects/1/stakeholders/1
  # PATCH/PUT projects/1/stakeholders/1.json
  def update
    respond_to do |format|
      if @stakeholder.update(stakeholder_params)
        format.html { redirect_to project_stakeholder_path(@project, @stakeholder), notice: 'Stakeholder was successfully updated.' }
        format.json { render :show, status: :ok, location: @stakeholder }
      else
        format.html { render :edit }
        format.json { render json: @stakeholder.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT projects/1/stakeholders/1/increase_commitment
  def increase_commitment
    respond_to do |format|
      if @stakeholder.increase_commitment
        format.html { redirect_to project_stakeholders_path(@project), notice: 'Nivel de compromiso aumentado'}
      else
        format.html { redirect_to project_stakeholders_path(@project), notice: 'No se pudo incrementar el nivel de compromiso' }
      end
    end
  end


  # DELETE projects/1/stakeholders/1
  # DELETE projects/1/stakeholders/1.json
  def destroy
    @stakeholder.destroy
    respond_to do |format|
      format.html { redirect_to project_stakeholders_url, notice: 'Stakeholder was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_stakeholder
      @stakeholder = Stakeholder.find(params[:id])
    end

    def set_project
      @project = Project.find(params[:project_id])
    end

    def set_admin
      if current_project_manager
        @admin = current_project_manager.has_role? :admin
      else
        @admin = false
      end
    end
    # Never trust parameters from the scary internet, only allow the white list through.
    def stakeholder_params
      params.require(:stakeholder).permit(:name, :commitment_level, :influence, :power)
    end
end
