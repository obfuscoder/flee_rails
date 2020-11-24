class AddCommissionRateToEvent < ActiveRecord::Migration[4.2]
  def change
    add_column :events, :commission_rate, :decimal, precision: 3, scale: 2
  end
end
