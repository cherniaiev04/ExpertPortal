class AddCommunicationLanguageToExperts < ActiveRecord::Migration[7.2]
  def change
    add_column :experts, :communication_language, :json
  end
end
