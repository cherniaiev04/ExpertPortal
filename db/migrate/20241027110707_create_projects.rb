class CreateProjects < ActiveRecord::Migration[7.2]
  def change
    create_table :projects do |t|
      t.string :name
      t.date :time_period_start
      t.date :time_period_end
      t.text :schedule
      t.string :participants
      t.string :location
      t.string :clients
      t.string :expertise
      t.string :project_type
      t.string :key_topics

      t.timestamps
    end
  end
end
