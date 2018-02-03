# frozen_string_literal: true

class AddActiveToSeller < ActiveRecord::Migration
  def change
    add_column :sellers, :active, :boolean
  end
end
