class CostPaymentPlansController < ApplicationController
  before_action :set_cost_payment_plan, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_project_manager!
  # GET /cost_payment_plans
  # GET /cost_payment_plans.json
  def index
    @cost_payment_plans = CostPaymentPlan.all
  end

  # GET /cost_payment_plans/1
  # GET /cost_payment_plans/1.json
  def show
  end

  # GET /cost_payment_plans/new
  def new
    @cost_payment_plan = CostPaymentPlan.new
  end

  # GET /cost_payment_plans/1/edit
  def edit
  end

  # POST /cost_payment_plans
  # POST /cost_payment_plans.json
  def create
    @cost_payment_plan = CostPaymentPlan.new(cost_payment_plan_params)

    respond_to do |format|
      if @cost_payment_plan.save
        format.html { redirect_to @cost_payment_plan, notice: 'Cost payment plan was successfully created.' }
        format.json { render :show, status: :created, location: @cost_payment_plan }
      else
        format.html { render :new }
        format.json { render json: @cost_payment_plan.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /cost_payment_plans/1
  # PATCH/PUT /cost_payment_plans/1.json
  def update
    respond_to do |format|
      if @cost_payment_plan.update(cost_payment_plan_params)
        format.html { redirect_to @cost_payment_plan, notice: 'Cost payment plan was successfully updated.' }
        format.json { render :show, status: :ok, location: @cost_payment_plan }
      else
        format.html { render :edit }
        format.json { render json: @cost_payment_plan.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /cost_payment_plans/1
  # DELETE /cost_payment_plans/1.json
  def destroy
    @cost_payment_plan.destroy
    respond_to do |format|
      format.html { redirect_to cost_payment_plans_url, notice: 'Cost payment plan was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_cost_payment_plan
      @cost_payment_plan = CostPaymentPlan.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def cost_payment_plan_params
      params.fetch(:cost_payment_plan, {})
    end
end
