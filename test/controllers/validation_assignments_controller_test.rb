require 'test_helper'

class ValidationAssignmentsControllerTest < ActionController::TestCase
  setup do
    @validation_assignment = validation_assignments(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:validation_assignments)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create validation_assignment" do
    assert_difference('ValidationAssignment.count') do
      post :create, validation_assignment: { field_id: @validation_assignment.field_id, validation_id: @validation_assignment.validation_id, value_id: @validation_assignment.value_id }
    end

    assert_redirected_to validation_assignment_path(assigns(:validation_assignment))
  end

  test "should show validation_assignment" do
    get :show, id: @validation_assignment
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @validation_assignment
    assert_response :success
  end

  test "should update validation_assignment" do
    patch :update, id: @validation_assignment, validation_assignment: { field_id: @validation_assignment.field_id, validation_id: @validation_assignment.validation_id, value_id: @validation_assignment.value_id }
    assert_redirected_to validation_assignment_path(assigns(:validation_assignment))
  end

  test "should destroy validation_assignment" do
    assert_difference('ValidationAssignment.count', -1) do
      delete :destroy, id: @validation_assignment
    end

    assert_redirected_to validation_assignments_path
  end
end
