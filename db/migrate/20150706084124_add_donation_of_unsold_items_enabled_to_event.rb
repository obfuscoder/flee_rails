class AddDonationOfUnsoldItemsEnabledToEvent < ActiveRecord::Migration[4.2]
  def change
    add_column :events, :donation_of_unsold_items_enabled, :boolean
  end
end
