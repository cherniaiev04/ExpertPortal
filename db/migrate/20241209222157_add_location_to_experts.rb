class AddLocationToExperts < ActiveRecord::Migration[7.2]
  def change
    add_column :experts, :location, :string
  end
end
