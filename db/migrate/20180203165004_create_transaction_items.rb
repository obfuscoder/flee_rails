# frozen_string_literal: true

class CreateTransactionItems < ActiveRecord::Migration
  def change
    create_table :transaction_items do |t|
      t.timestamps null: false
      t.belongs_to :transaction, index: true, foreign_key: true, null: false
      t.belongs_to :item, index: true, foreign_key: true, null: false
      t.index %i[transaction_id item_id], unique: true
    end
  end
end
