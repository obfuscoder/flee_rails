class AddDonationEnforcedToCategory < ActiveRecord::Migration[4.2]
  def change
    add_column :categories, :donation_enforced, :boolean
  end
end
