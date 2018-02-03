# frozen_string_literal: true

class AddDonationToItem < ActiveRecord::Migration
  def change
    add_column :items, :donation, :boolean
  end
end
