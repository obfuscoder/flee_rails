# frozen_string_literal: true

class RemoveEmailIndexFromSellers < ActiveRecord::Migration
  def change
    remove_index :sellers, :email
  end
end
