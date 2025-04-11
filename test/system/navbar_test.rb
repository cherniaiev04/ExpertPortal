require 'application_system_test_case'

class NavbarTest < ApplicationSystemTestCase
  include Devise::Test::IntegrationHelpers

  setup do
    @admin = users(:admin_janet)
    @user = users(:user_bob)
    @expert = users(:expert_alice)
  end

  test 'visiting experts index' do
    sign_in @admin

    visit root_path

    click_on I18n.t('experts.experts')

    assert_selector 'h1', text: I18n.t('experts.experts')
  end

  test 'visiting projects index' do
    sign_in @admin

    visit root_path

    click_on I18n.t('projects.projects')

    assert_selector 'h1', text: I18n.t('projects.projects')
  end

  test 'visiting categories index' do
    sign_in @admin

    visit root_path

    click_on I18n.t('categories.categories')

    assert_selector 'h1', text: I18n.t('categories.categories')
  end

  test 'sign out as user' do
    sign_in @user

    visit root_path

    find("[aria-label='Abmelden']").click

    assert_selector 'h3', text: I18n.t('general.sign_in')
  end
end
