class AddForeignKeyToExpertsProjects < ActiveRecord::Migration[7.2]
  def change
    add_foreign_key :experts_projects, :experts
    add_foreign_key :experts_projects, :projects
  end
end
