class HumanResourcesController < ApplicationController
  before_action :set_human_resource, only: [:show, :edit, :update, :destroy, :clone]
  before_action :authenticate_project_manager!
  before_action :set_admin
  # GET /human_resources
  # GET /human_resources.json
  def index
    if @admin
      @human_resources = HumanResource.from_admin
    else
      @human_resources = current_project_manager.project.human_resources
    end
  end

  # GET /human_resources/1
  # GET /human_resources/1.json
  def show
  end

  # GET /human_resources_shop
  def shop
    human_resources = HumanResource.from_admin
    @your_human_resources = current_project_manager.projects.first.human_resources
    @available = human_resources.to_a.keep_if { |hr| @your_human_resources.where(name: hr.name).length == 0 }
  end

  # POST /human_resources/:id/clone
  def clone
    hr = @human_resource.dup
    hr.project_id = current_project_manager.projects.first.id
    hr.is_from_admin = @admin
    respond_to do |format|
      if hr.save
        format.html { redirect_to human_resources_shop_path, notice: 'Recurso humano agregado correctamente' } 
      else
        format.html { render human_resources_shop_path, notice: 'Ocurrió un error, por favor inténtalo de nuevo' }
      end
    end
  end

  # GET /human_resources/new
  def new
    @human_resource = HumanResource.new
  end

  # GET /human_resources/1/edit
  def edit
  end

  # POST /human_resources
  # POST /human_resources.json
  def create
    @human_resource = HumanResource.new(human_resource_params)
    @human_resource.is_from_admin = @admin
    respond_to do |format|
      if @human_resource.save
        format.html { redirect_to @human_resource, notice: 'Human resource was successfully created.' }
        format.json { render :show, status: :created, location: @human_resource }
      else
        format.html { render :new }
        format.json { render json: @human_resource.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /human_resources/1
  # PATCH/PUT /human_resources/1.json
  def update
    respond_to do |format|
      if @human_resource.update(human_resource_params)
        format.html { redirect_to @human_resource, notice: 'Human resource was successfully updated.' }
        format.json { render :show, status: :ok, location: @human_resource }
      else
        format.html { render :edit }
        format.json { render json: @human_resource.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /human_resources/1
  # DELETE /human_resources/1.json
  def destroy
    @human_resource.destroy
    respond_to do |format|
      format.html { redirect_to human_resources_url, notice: 'Human resource was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_human_resource
      @human_resource = HumanResource.find(params[:id])
    end

    def set_admin
      @admin = current_project_manager.has_role? :admin
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def human_resource_params
      params.require(:human_resource).permit(:name, :project_id, :is_from_admin, :experience, :salary, :resource_type)
    end
end
