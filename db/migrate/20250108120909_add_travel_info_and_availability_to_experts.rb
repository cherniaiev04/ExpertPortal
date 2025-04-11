class AddTravelInfoAndAvailabilityToExperts < ActiveRecord::Migration[7.2]
  def change
    add_column :experts, :travel_info, :text
    add_column :experts, :short_term_availability, :string
  end
end
