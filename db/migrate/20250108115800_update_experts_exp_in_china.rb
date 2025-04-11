class UpdateExpertsExpInChina < ActiveRecord::Migration[7.2]
  def change
    remove_column :experts, :profExpInChina, :text
    remove_column :experts, :privExpInChina, :text

    add_column :experts, :expInChina, :text
  end
end
