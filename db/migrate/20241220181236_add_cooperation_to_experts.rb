class AddCooperationToExperts < ActiveRecord::Migration[7.2]
  def change
    add_column :experts, :cooperation, :string
  end
end
