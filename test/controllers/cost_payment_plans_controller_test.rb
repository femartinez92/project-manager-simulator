require 'test_helper'

class CostPaymentPlansControllerTest < ActionController::TestCase
  setup do
    @cost_payment_plan = cost_payment_plans(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:cost_payment_plans)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create cost_payment_plan" do
    assert_difference('CostPaymentPlan.count') do
      post :create, cost_payment_plan: {  }
    end

    assert_redirected_to cost_payment_plan_path(assigns(:cost_payment_plan))
  end

  test "should show cost_payment_plan" do
    get :show, id: @cost_payment_plan
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @cost_payment_plan
    assert_response :success
  end

  test "should update cost_payment_plan" do
    patch :update, id: @cost_payment_plan, cost_payment_plan: {  }
    assert_redirected_to cost_payment_plan_path(assigns(:cost_payment_plan))
  end

  test "should destroy cost_payment_plan" do
    assert_difference('CostPaymentPlan.count', -1) do
      delete :destroy, id: @cost_payment_plan
    end

    assert_redirected_to cost_payment_plans_path
  end
end
