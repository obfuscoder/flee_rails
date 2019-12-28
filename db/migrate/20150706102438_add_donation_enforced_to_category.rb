class AddDonationEnforcedToCategory < ActiveRecord::Migration
  def change
    add_column :categories, :donation_enforced, :boolean
  end
end
