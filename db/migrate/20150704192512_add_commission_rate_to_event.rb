# frozen_string_literal: true

class AddCommissionRateToEvent < ActiveRecord::Migration
  def change
    add_column :events, :commission_rate, :decimal, precision: 3, scale: 2
  end
end
