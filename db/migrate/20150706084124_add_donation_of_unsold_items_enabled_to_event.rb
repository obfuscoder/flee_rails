# frozen_string_literal: true

class AddDonationOfUnsoldItemsEnabledToEvent < ActiveRecord::Migration
  def change
    add_column :events, :donation_of_unsold_items_enabled, :boolean
  end
end
