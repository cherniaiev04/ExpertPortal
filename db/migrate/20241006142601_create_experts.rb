class CreateExperts < ActiveRecord::Migration[7.2]
  def change
    create_table :experts do |t|
      t.string :name
      t.string :firstname
      t.string :email
      t.string :expertise
      t.string :institution
      t.string :additionalInfo

      t.timestamps
    end
  end
end
