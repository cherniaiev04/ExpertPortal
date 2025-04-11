class AddInstitutionBoolToExperts < ActiveRecord::Migration[7.2]
  def change
    add_column :experts, :institution_bool, :boolean, null: false, default: false
  end
end
