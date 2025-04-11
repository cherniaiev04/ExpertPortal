# test/integration/user_flows_user.rb
require 'test_helper'

class PermissionsUserTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @category = categories(:computer_science)
    @expert = experts(:alice)
    @project = projects(:project_expertgrid)
    @user = users(:user_bob)
    sign_in @user
  end

  test 'should get projects index' do
    get projects_path
    assert_response :success
  end

  test 'should get new project' do
    get new_project_path
    assert_response :redirect
  end

  test 'should get edit project' do
    get edit_project_path(@project)
    assert_response :redirect
  end

  test 'should get project show' do
    get project_path(@project)
    assert_response :success
  end

  test 'should delete project' do
    delete project_path(@project)
    assert_redirected_to experts_path
  end

  test 'should get experts index' do
    get experts_path
    assert_response :success
  end

  test 'should get experts edit' do
    get edit_expert_path(@expert)
    assert_redirected_to experts_path
  end

  test 'should get experts show' do
    get expert_path(@expert)
    assert_response :success
  end

  test 'should delete expert' do
    delete expert_path(@expert)
    assert_redirected_to experts_path
  end

  test 'should not get users index' do
    get users_path
    assert_redirected_to '/experts'
  end

  test 'should not get users edit' do
    get edit_user_path(@user)
    assert_redirected_to '/experts'
  end

  test 'should not delete user' do
    delete user_path(@user)
    assert_redirected_to '/experts'
  end

  test 'should not get categories index' do
    get categories_path
    assert_redirected_to '/experts'
  end

  test 'should not get categories new' do
    get new_category_path
    assert_redirected_to '/experts'
  end

  test 'should not get categories edit' do
    get edit_category_path(@category)
    assert_redirected_to '/experts'
  end

  test 'should not delete category' do
    delete category_path(@category)
    assert_redirected_to '/experts'
  end
end
