class AddCategoryToExperts < ActiveRecord::Migration[7.2]
  def change
    add_reference :experts, :category, foreign_key: true
  end
end
