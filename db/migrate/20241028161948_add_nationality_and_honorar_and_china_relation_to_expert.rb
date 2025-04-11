class AddNationalityAndHonorarAndChinaRelationToExpert < ActiveRecord::Migration[7.2]
  def change
    add_column :experts, :nationality, :string
    add_column :experts, :hourlyRate, :float
    add_column :experts, :dailyRate, :float
    add_column :experts, :profExpInChina, :text
    add_column :experts, :privExpInChina, :text
  end
end
