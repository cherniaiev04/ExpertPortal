class RemoveCategoryIdFromExperts < ActiveRecord::Migration[7.2]
  def change
    remove_column :experts, :category_id, :integer
  end
end
