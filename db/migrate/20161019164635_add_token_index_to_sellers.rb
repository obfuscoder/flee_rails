# frozen_string_literal: true

class AddTokenIndexToSellers < ActiveRecord::Migration
  def change
    add_index :sellers, :token, unique: true, where: 'deleted_at IS NULL'
  end
end
