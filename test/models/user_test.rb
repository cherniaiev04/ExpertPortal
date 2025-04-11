require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test 'assert fixtures' do
    assert_equal User.count, 4
    assert_equal users(:expert_alice).expert, experts(:alice)
  end

  test 'create valid user' do
    user = User.create(
      email: 'somerandom@email.com',
      password: 'password123'
    )
    assert user.save
    user.reload
    assert_equal user.email, 'somerandom@email.com'
    assert_equal user.role, 'expert'
    assert_equal user.initiated, false
  end

  test 'connect user to expert' do
    email = experts(:bob).email
    user = User.create(
      email:,
      password: '123456',
      expert_id: experts(:bob).id,
      initiated: true
    )
    assert user.save
    assert_equal user.expert, experts(:bob)
  end

  test "don't create user without email" do
    user = User.create(
      password: '123456'
    )
    assert_not user.save
    assert_includes user.errors[:email], I18n.t('users.errors.email_missing')
  end

  test "don't create user without password" do
    user = User.create(
      email: 'some@mail.com'
    )
    assert_not user.save
    assert_includes user.errors[:password], I18n.t('users.errors.password_missing')
  end

  test "don't create user with too short password" do
    user = User.create(
      email: 'some@mail.com',
      password: '12345'
    )
    assert_not user.save
    assert_includes user.errors[:password], I18n.t('users.errors.password_too_short')
  end

  test 'update user email' do
    user = users(:user_bob)
    assert user.update(email: 'bob@bingo.de')
    user.reload
    assert_equal user.email, 'bob@bingo.de'
  end

  test "don't update last admins role" do
    admin = users(:admin_janet)
    admin.update(role: 'expert')
    admin.reload
    assert_equal admin.role, 'admin'
  end

  test 'delete user' do
    assert_difference('User.count', -1) do
      users(:user_bob).destroy
    end
  end

  test 'delete expert-user' do
    assert_difference('User.count', -1) do
      users(:expert_eve).destroy
    end
  end

  test "don't delete connected expert on deleting expert user" do
    assert_no_difference('Expert.count') do
      users(:expert_alice).destroy
    end
  end

  test "don't delete last admin" do
    assert_no_difference('Expert.count') do
      users(:admin_janet).destroy
    end
    assert_equal users(:admin_janet).email, 'janet@fiti.de'
  end
end
