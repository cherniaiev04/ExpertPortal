class AddDeletedAtToCourseModules < ActiveRecord::Migration[7.2]
  def change
    add_column :course_modules, :deleted_at, :datetime
  end
end
