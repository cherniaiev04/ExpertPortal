require 'test_helper'

class CategoryTest < ActiveSupport::TestCase
  test 'assert fixtures' do
    assert_equal Category.count, 5
    assert_includes categories(:computer_science).experts, experts(:alice)
  end

  test 'create valid category' do
    category = Category.create(name: 'Industrie 4.0')
    assert category.save
    category.reload
    assert_equal category.name, 'Industrie 4.0'
    assert_not category.deleted?
  end

  test "don't create category without name" do
    category = Category.create(name: '')
    assert_not category.save
    assert_includes category.errors[:name], I18n.t('categories.errors.name_missing')
  end

  test "don't create category with duplicate name" do
    category = Category.create(name: categories(:computer_science).name)
    assert_not category.save
    assert_includes category.errors[:name], I18n.t('categories.errors.name_not_unique')
  end

  test 'update category' do
    category = categories(:computer_science)
    category.update(name: 'Computer Wissenschaft')
    category.reload
    assert_equal category.name, 'Computer Wissenschaft'
  end

  test 'soft delete category' do
    category = categories(:computer_science)
    assert_no_difference('Category.count') do
      category.soft_delete
    end
    assert category.deleted?
    assert_equal Category.archived.count, 1
    assert_equal Category.active.count, 4
  end

  test 'delete category' do
    assert_difference('Category.count', -1) do
      categories(:computer_science).destroy
    end
  end
end
