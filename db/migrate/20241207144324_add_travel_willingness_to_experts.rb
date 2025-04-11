class AddTravelWillingnessToExperts < ActiveRecord::Migration[7.2]
  def change
    add_column :experts, :travel_willingness, :json
  end
end
