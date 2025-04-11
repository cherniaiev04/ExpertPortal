# test/integration/user_flows_expert.rb
require 'test_helper'

class PermissionsExpertTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @category = categories(:computer_science)
    @expert = experts(:alice)
    @other_expert = experts(:evelina)
    @project = projects(:project_expertgrid)
    @expert_user = users(:expert_alice)
    sign_in @expert_user
  end

  test 'should get experts/me if user is initiated' do
    #@expert_user.update(initiated: true, expert_id: @expert.id)
    get '/experts/me'
    assert_response :redirect
    assert_redirected_to expert_path(@expert_user.expert)
  end

  test 'should get experts/new if user is not initiated' do
    @expert_user.update(initiated: false)
    get new_expert_path
    assert_response :success
  end

  test 'should redirect from experts/new if user is initiated' do
    @expert_user.update(initiated: true)
    get new_expert_path
    assert_redirected_to '/experts/me'
  end

  test 'should not get projects index' do
    @expert_user.update(initiated: true)
    get projects_path
    assert_redirected_to '/experts/me'
  end

  test 'should not get projects new' do
    @expert_user.update(initiated: true)
    get new_project_path
    assert_redirected_to '/experts/me'
  end

  test 'should not get projects edit' do
    get edit_project_path(@project)
    assert_redirected_to '/experts/me'
  end

  test 'should not get projects show' do
    get project_path(@project)
    assert_redirected_to '/experts/me'
  end

  test 'should not delete project' do
    delete project_path(@project)
    assert_redirected_to '/experts/me'
  end

  test 'should not get experts index' do
    get experts_path
    assert_redirected_to '/experts/me'
  end

  test 'should not get experts edit' do
    get edit_expert_path(@expert)
    assert :success
  end

  test 'should not get experts show for another expert' do
    @expert_user.update(initiated: true, expert_id: @expert.id)
    get expert_path(@other_expert)
    assert_redirected_to '/experts/me'
  end

  test 'should not delete expert' do
    delete expert_path(@expert)
    assert_redirected_to '/experts/me'
  end

  test 'should not get users index' do
    get users_path
    assert_redirected_to '/experts/me'
  end

  test 'should not get users edit' do
    get edit_user_path(@expert_user)
    assert_redirected_to '/experts/me'
  end

  test 'should not delete user' do
    delete user_path(@expert_user)
    assert_redirected_to '/experts/me'
  end

  test 'should not get categories index' do
    get categories_path
    assert_redirected_to '/experts/me'
  end

  test 'should not get categories new' do
    get new_category_path
    assert_redirected_to '/experts/me'
  end

  test 'should not get categories edit' do
    get edit_category_path(@category)
    assert_redirected_to '/experts/me'
  end

  test 'should not delete category' do
    delete category_path(@category)
    assert_redirected_to '/experts/me'
  end
end
