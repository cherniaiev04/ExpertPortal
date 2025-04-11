class AddLessonLanguageToExperts < ActiveRecord::Migration[7.2]
  def change
    add_column :experts, :lesson_language, :json
  end
end
