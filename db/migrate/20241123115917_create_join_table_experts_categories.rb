class CreateJoinTableExpertsCategories < ActiveRecord::Migration[7.2]
  def change
    create_join_table :experts, :categories do |t|
      t.index %i[expert_id category_id]
      t.index %i[category_id expert_id]
    end
  end
end
