class AddTitleAndAnredeToExperts < ActiveRecord::Migration[7.2]
  def change
    add_column :experts, :title, :string
    add_column :experts, :salutation, :string
  end
end
