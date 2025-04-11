class ChangeColumsOnTextForArray < ActiveRecord::Migration[7.2]
  def change
    change_column :projects, :location, :text
    change_column :projects, :key_topics, :text
    change_column :projects, :project_type, :text
  end
end
