require 'test_helper'

class CourseModuleTest < ActiveSupport::TestCase
  test 'assert fixtures' do
    assert_equal CourseModule.count, 5
    assert_includes course_modules(:databases).experts, experts(:alice)
  end

  test 'create valid course_module' do
    course_module = CourseModule.create(name: 'Industrie 4.0')
    assert course_module.save
    course_module.reload
    assert_equal course_module.name, 'Industrie 4.0'
    assert_not course_module.deleted?
  end
 
  # Test notwendig?
  test "don't create course_module without name" do
    course_module = CourseModule.create(name: '')
    assert_not course_module.save
    assert_includes course_module.errors[:name], I18n.t('course_modules.errors.name_missing')
  end

  test "don't create course_module with duplicate name" do
    course_module = CourseModule.create(name: course_modules(:databases).name)
    assert_not course_module.save
    assert_includes course_module.errors[:name], I18n.t('course_modules.errors.name_not_unique')
  end

  test 'update course_module' do
    course_module = course_modules(:databases)
    course_module.update(name: 'Datenbanken')
    course_module.reload
    assert_equal course_module.name, 'Datenbanken'
  end

  test 'soft delete course_module' do
    course_module = course_modules(:databases)
    assert_no_difference('CourseModule.count') do
      course_module.soft_delete
    end
    assert course_module.deleted?
    assert_equal CourseModule.archived.count, 1
    assert_equal CourseModule.active.count, 4
  end

  test 'delete course_module' do
    assert_difference('CourseModule.count', -1) do
      course_modules(:databases).destroy
    end
  end
end
