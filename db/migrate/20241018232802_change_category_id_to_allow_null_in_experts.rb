class ChangeCategoryIdToAllowNullInExperts < ActiveRecord::Migration[7.2]
  def change
    change_column_null :experts, :category_id, true
  end
end
