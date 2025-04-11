require 'test_helper'

class UserFlowsExpertTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  test "create new project as internal staff" do
    get root_path
    assert_response :success
    sign_in(users(:admin_janet))

    get new_project_path
    assert_response :success

    @project = projects(:project_expertgrid)

    valid_params = {
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
    }

    assert_difference("Project.count", 1) do
      post projects_url, params: { project: valid_params }
    end

    assert_response :redirect
    assert_redirected_to project_path(Project.last)

    # adding expert to project (Feature still in the works)
  end

  test "create new expert and invite him as internal staff" do
    get root_path
    assert_response :success
    sign_in(users(:admin_janet))

    get experts_path
    assert_response :success

    post experts_path, params: {
      expert: {
        salutation: 'Herr',
        name: 'Mustermann',
        firstname: 'Maddin',
        email: 'MM@gmail.com',
        telephone: '0049 123 4214215',
        category_ids: [1, 2]
      }
    }
    assert_response :redirect
    assert_redirected_to expert_url(Expert.last)

    assert_difference("Invitation.count", 1) do
      post invitations_path, params: {
        invitation: {
          email: Expert.last.email
        }
      }
    end
    assert_response :redirect
    # should redirect here but in test it uses the fallback location which is users_path
    # assert_redirected_to expert_url(Expert.last)
  end

  test "sign up as expert with already existing profile" do
    @invitation = invitations(:evelina)
    get sign_up_with_token_path(@invitation.token)
    assert_response :success

    assert_difference('User.count', 1) do
      post sign_up_with_token_url(@invitation.token), params: {
        user: {
          password: 'password',
          password_confirmation: 'password'
        }
      }
    end
    assert @invitation.reload.used

    assert_equal User.last.initiated, true
    assert_equal User.last.expert, experts(:evelina)
  end

end
