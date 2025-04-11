class AddTelephoneToExperts < ActiveRecord::Migration[7.2]
  def change
    add_column :experts, :telephone, :string
  end
end
