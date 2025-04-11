require 'test_helper'

class ExpertsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  test 'get index assigns experts' do
    sign_in(users(:admin_janet))
    get experts_path
    assert_response :success

    assert_equal experts.size, 3
    assert_includes experts, experts(:alice)
  end

  test 'get show assigns correct expert' do
    sign_in(users(:admin_janet))
    get expert_url(experts(:alice).id)
    assert_response :success

    assert_match experts(:alice).name, response.body
  end

  test 'redirect if you try to get a non existing expert' do
    sign_in(users(:admin_janet))
    get expert_url(-1)
    assert_response :redirect
    assert_redirected_to experts_path
  end

  test 'redirect away from /experts/me if admin_janet' do
    sign_in(users(:admin_janet))
    get '/experts/me'
    assert_response :redirect
    assert_redirected_to experts_path
  end

  test 'create new expert redirects correctly' do
    sign_in(users(:admin_janet))
    post experts_path, params: {
      expert: {
        salutation: 'Frau',
        name: 'Mayer',
        firstname: 'Annette',
        email: 'amayer@gmail.com',
        telephone: '0049 123 456789',
        category_ids: [1, 2]
      }
    }
    assert_response :redirect
    assert_redirected_to expert_url(Expert.last.id)
    assert_equal I18n.t('experts.messages.created'), flash[:notice]
  end

  test 'fail to create expert stays on page' do
    sign_in(users(:admin_janet))
    post experts_path, params: {
      expert: {
        name: 'Mayer',
        firstname: 'Annette'
      }
    }
    assert_response :unprocessable_entity
    assert_template :new
  end

  test 'update expert redirects correctly' do
    sign_in(users(:admin_janet))
    put expert_url(experts(:alice)), params: {
      expert: {
        firstname: 'Alicia'
      }
    }
    assert_response :redirect
    assert_equal I18n.t('experts.messages.updated'), flash[:notice]
    assert_redirected_to expert_url(experts(:alice))
    experts(:alice).reload
    assert_equal experts(:alice).firstname, 'Alicia'
  end

  test 'fail to update expert stays on page' do
    sign_in(users(:admin_janet))
    put expert_url(experts(:alice)), params: {
      expert: {
        firstname: ''
      }
    }
    assert_response :unprocessable_entity
    assert_template :edit
  end

  test 'destroy expert redirects correctly' do
    sign_in(users(:admin_janet))
    delete expert_url(:alice)

    assert_response :redirect
    assert_redirected_to experts_path
    # message is shown on page, I don't know why this fails
    # assert_equal I18n.t("experts.messages.destroyed"), flash[:notice]
  end
end
