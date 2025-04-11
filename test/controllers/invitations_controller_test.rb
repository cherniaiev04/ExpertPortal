require 'test_helper'

class InvitationsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @admin_user = users(:admin_janet)
    @invitation = invitations(:valid)
    @expired_invitation = invitations(:expired)
  end

  test 'should redirect new if not admin' do
    get new_invitation_path
    assert_redirected_to '/experts'
    assert_equal 'Sie haben nicht die nötige Berechtigung, um auf diese Seite zuzugreifen.', flash[:alert]
  end

  test 'should create invitation as admin' do
    sign_in @admin_user
    assert_difference('Invitation.count', 1) do
      post invitations_path, params: { invitation: { email: 'newuser@example.com' } }
    end
    assert_redirected_to users_path
  end

  test 'should get sign_up with valid token' do
    get sign_up_with_token_path(@invitation.token)
    assert_response :success
    assert_select 'input[value=?]', @invitation.email
  end

  test 'should redirect sign_up with expired token' do
    get sign_up_with_token_path(@expired_invitation.token)
    assert_redirected_to root_path
    assert_equal I18n.t('users.errors.expired_token'), flash[:alert]
  end

  test 'should redirect sign_up with used token' do
    @invitation.update(used: true)
    get sign_up_with_token_path(@invitation.token)
    assert_redirected_to root_path
    assert_equal I18n.t('users.errors.expired_token'), flash[:alert]
  end

  test 'should redirect sign_up with invalid token' do
    get sign_up_with_token_path('invalidtoken')
    assert_redirected_to root_path
    assert_equal I18n.t('users.errors.invalid_token'), flash[:alert]
  end

  test 'should create user and mark invitation as used with valid token' do
    assert_difference('User.count', 1) do
      post sign_up_with_token_url(@invitation.token), params: {
        user: { password: 'password', password_confirmation: 'password' }
      }
    end
    assert_equal I18n.t('users.notice.register_success'), flash[:notice]
    assert @invitation.reload.used
  end

  test 'should not create user if password confirmation does not match' do
    assert_no_difference('User.count') do
      post sign_up_with_token_url(@invitation.token), params: {
        user: { password: 'password', password_confirmation: 'different' }
      }
    end
    assert_template :sign_up
    assert_select 'div.alert', I18n.t("activerecord.errors.messages.confirmation")
    assert_not @invitation.reload.used
  end

  test 'should not create user with expired invitation' do
    @expired_invitation.update(used: false)
    assert_no_difference('User.count') do
      post sign_up_with_token_url(@expired_invitation.token), params: {
        user: { password: 'password', password_confirmation: 'password' }
      }
    end
    assert_redirected_to root_path
    assert_equal I18n.t('users.errors.expired_token'), flash[:alert]
  end

  test 'should not create user with already used invitation' do
    @invitation.update(used: true)
    assert_no_difference('User.count') do
      post sign_up_with_token_url(@invitation.token), params: {
        user: { password: 'password', password_confirmation: 'password' }
      }
    end
    assert_redirected_to root_path
    assert_equal I18n.t('users.errors.expired_token'), flash[:alert]
  end
end
