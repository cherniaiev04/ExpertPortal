require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @user = users(:user_bob)
    @admin = users(:admin_janet)
    sign_in @admin
  end

  test 'should get index' do
    get users_url
    assert_response :success
    assert_not_nil assigns(:users)
  end

  test 'should update user' do
    patch user_url(@user), params: { user: { email: 'updated_email@example.com', role: 'admin' } }
    @user.reload
    assert_redirected_to users_url
    assert_equal 'updated_email@example.com', @user.email
    assert_equal 'admin', @user.role
  end

  test 'should destroy user' do
    assert_difference('User.count', -1) do
      delete user_url(@user)
    end
    assert_redirected_to users_url
  end

  test 'should not update the last admin to another role' do
    patch user_path(@admin), params: { user: { role: 'user' } }

    @admin.reload
    assert_equal 'admin', @admin.role
    assert_includes response.body, I18n.t('users.errors.change_last_admin')
  end

  test 'should not delete the last admin' do
    assert_no_difference('User.count') do
      delete user_path(@admin)
    end

    assert_equal I18n.t('users.errors.delete_last_admin'), flash[:alert]
  end
end
