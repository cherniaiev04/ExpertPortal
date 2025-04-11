class AddForeignKeyToCategoriesExperts < ActiveRecord::Migration[7.2]
  def change
    add_foreign_key :categories_experts, :experts
    add_foreign_key :categories_experts, :categories
  end
end
