require 'test_helper'

class CategoriesControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  test 'get index assigns active and archived categories' do
    sign_in(users(:admin_janet))
    get categories_path
    assert_response :success

    assert_equal categories.size, 5
    assert_includes categories, categories(:computer_science)
  end

  test 'create new category redirects correctly' do
    sign_in(users(:admin_janet))
    post categories_path, params: {
      category: {
        name: "Fischen"
      }
    }
    assert_response :redirect
    assert_redirected_to categories_path
    assert_equal I18n.t('categories.messages.created'), flash[:notice]
  end

  test 'fail to create category stays on page' do
    sign_in(users(:admin_janet))
    post categories_path, params: {
      category: {
        name: ""
      }
    }
    assert_response :unprocessable_entity
    assert_template :new
  end

  test 'update category redirects correctly' do
    sign_in(users(:admin_janet))
    put category_url(categories(:computer_science)), params: {
      category: {
        name: 'Computer Wissenschaften'
      }
    }
    assert_response :redirect
    assert_equal I18n.t("categories.messages.updated"), flash[:notice]
    assert_redirected_to categories_path
    categories(:computer_science).reload
    assert_equal categories(:computer_science).name, 'Computer Wissenschaften'
  end

  test 'fail to update category stays on page' do
    sign_in(users(:admin_janet))
    put category_url(categories(:computer_science)), params: {
      category: {
        name: ''
      }
    }
    assert_response :unprocessable_entity
    assert_template :edit
  end

  test 'hard delete category redirects correctly' do
    sign_in(users(:admin_janet))
    delete category_url(categories(:religion))

    assert_response :redirect
    assert_redirected_to categories_path
    assert_equal I18n.t("categories.errors.hard_deleted"), flash[:notice]
  end

  test 'soft delete category redirects correctly' do
    sign_in(users(:admin_janet))
    delete category_url(categories(:computer_science))

    assert_response :redirect
    assert_redirected_to categories_path
    assert_equal I18n.t("categories.errors.soft_deleted"), flash[:notice]
  end
end
