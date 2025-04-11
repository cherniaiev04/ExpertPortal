require 'test_helper'

class ProjectsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @project = projects(:project_expertgrid)
    @admin = users(:admin_janet)
    sign_in @admin
  end

  # Create Project tests

  test "should create project with all params" do
  valid_params = {
    name: @project.name,
    time_period_start: @project.time_period_start,
    time_period_end: @project.time_period_end,
    schedule: @project.schedule,
    participants: @project.participants,
    location: @project.location, # This must be an array
    clients: @project.clients,
    expertise: @project.expertise,
    project_type: @project.project_type, # This must be an array
    key_topics: @project.key_topics # This must be an array
  }

  # Assert that the project count increases by 1
  assert_difference("Project.count", 1) do
    post projects_url, params: { project: valid_params }
  end

  # Assert redirection and flash message
  assert_redirected_to project_url(Project.last)
  assert_equal "Projekt wurde erfolgreich erstellt.", flash[:notice]
  end

  test 'should not create project without any params' do
    assert_no_difference 'Project.count' do
      post projects_url, params: { project: {
        name: '',
        time_period_start: nil,
        time_period_end: nil,
        schedule: "",
        participants: "",
        location: [],
        clients: "",
        expertise: "",
        project_type: [],
        key_topics: [] } }
    end

    assert_template :new
    # assert_select 'h2', /#{I18n.t('projects.errors.single_error')}|#{I18n.t('projects.errors.multiple_errors')}/
  end

  # GET Tests

  test 'should get index' do
    get projects_url
    assert_response :success
  end

  test 'should get index with search' do
    get projects_url, params: { search: 'Xpert' }

    assert_response :success
    assert_select 'h5', text: /Xpert/, count: 1
  end

  test 'should get new' do
    get new_project_url
    assert_response :success
  end

  test 'should show project' do
    get project_url(@project)
    assert_response :success
  end

  test 'should return not found when trying to show non-existent project' do
    get project_url(-1)
    assert_response :not_found
  end

  test 'should get edit' do
    get project_url(@project)
    assert_response :success
  end

  test 'should edit project and display current values' do
    get edit_project_url(@project)
    assert_response :success
    assert_select 'input[name="project[name]"][value=?]', @project.name
    assert_select 'input[name="project[time_period_start]"][value=?]', @project.time_period_start.strftime('%Y-%m-%d')
    assert_select 'input[name="project[time_period_end]"][value=?]', @project.time_period_end.strftime('%Y-%m-%d')
  end

  test 'should return not found when trying to edit non-existent project' do
    get edit_project_url(-1)
    assert_response :not_found
  end

  # UPDATE

  test 'should update project with valid params' do
    Project.new(
      name: @project.name,
      time_period_start: @project.time_period_start,
      time_period_end: @project.time_period_end,
      schedule: @project.schedule,
      participants: @project.participants,
      location: @project.location,
      clients: @project.clients,
      expertise: @project.expertise,
      project_type: @project.project_type,
      key_topics: @project.key_topics
    )

    patch project_url(@project), params: { project: { name: 'Aktualisiertes Projekt' } }

    @project.reload

    assert_redirected_to project_url(@project)
    assert_equal I18n.t('projects.messages.refreshed_success'), flash[:notice], 'Flash message not set correctly'
    assert_equal 'Aktualisiertes Projekt', @project.name, "Project's name wasn't updated"
  end

  test 'should not update project with nil params' do
    Expert.create(firstname: 'Max', name: 'Muster')
    
    patch project_url(@project), params: { project: {
      name: nil,
      time_period_start: nil,
      time_period_end: nil
    } }

    assert_response :unprocessable_entity
    # assert_select 'h2', /#{I18n.t('projects.errors.single_error')}|#{I18n.t('projects.errors.multiple_errors')}/
  end

  # DELETE

  test 'should destroy project' do
    assert_difference('Project.count', -1) do
      delete project_url(@project)
    end

    assert_redirected_to projects_url
    assert_equal I18n.t('projects.messages.deleted_success'), flash[:notice]
  end

  test 'should not destroy non-existent project' do
    assert_no_difference('Project.count') do
      delete project_url(-1)
    end

    assert_response :not_found
  end
end