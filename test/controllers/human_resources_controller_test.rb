require 'test_helper'

class HumanResourcesControllerTest < ActionController::TestCase
  setup do
    @human_resource = human_resources(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:human_resources)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create human_resource" do
    assert_difference('HumanResource.count') do
      post :create, human_resource: { experience: @human_resource.experience, is_from_admin: @human_resource.is_from_admin, name: @human_resource.name, project_id: @human_resource.project_id, salary: @human_resource.salary }
    end

    assert_redirected_to human_resource_path(assigns(:human_resource))
  end

  test "should show human_resource" do
    get :show, id: @human_resource
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @human_resource
    assert_response :success
  end

  test "should update human_resource" do
    patch :update, id: @human_resource, human_resource: { experience: @human_resource.experience, is_from_admin: @human_resource.is_from_admin, name: @human_resource.name, project_id: @human_resource.project_id, salary: @human_resource.salary }
    assert_redirected_to human_resource_path(assigns(:human_resource))
  end

  test "should destroy human_resource" do
    assert_difference('HumanResource.count', -1) do
      delete :destroy, id: @human_resource
    end

    assert_redirected_to human_resources_path
  end
end
