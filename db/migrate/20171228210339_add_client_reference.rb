class AddClientReference < ActiveRecord::Migration
  def change
    add_reference :categories, :client, index: true
    add_reference :events, :client, index: true
    add_reference :sellers, :client, index: true
    add_reference :stock_items, :client, index: true
    add_reference :users, :client, index: true
  end
end
