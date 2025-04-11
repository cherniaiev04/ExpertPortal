require 'application_system_test_case'

class InvitationsTest < ApplicationSystemTestCase
  include Devise::Test::IntegrationHelpers

  setup do
    @admin_user = users(:admin_janet)
    @invitation = invitations(:valid)
  end

  test 'create invitation token and display flash notice' do
    sign_in @admin_user
    visit users_path
    fill_in 'invitation_email', with: 'testuser@example.com'
    click_button I18n.t('users.send_token')

    assert_selector '.alert.alert-success', text: I18n.t('users.notice.token_created')
  end
end
