# frozen_string_literal: true

class AddEmailIndexToSellers < ActiveRecord::Migration
  def change
    add_index :sellers, :email, unique: true, where: 'deleted_at IS NULL'
  end
end
