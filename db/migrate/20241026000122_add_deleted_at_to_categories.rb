class AddDeletedAtToCategories < ActiveRecord::Migration[7.2]
  def change
    add_column :categories, :deleted_at, :datetime
  end
end
