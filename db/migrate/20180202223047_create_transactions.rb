# frozen_string_literal: true

class CreateTransactions < ActiveRecord::Migration
  def change
    create_table :transactions do |t|
      t.timestamps null: false
      t.string :number, limit: 48, null: false
      t.references :event, index: true, foreign_key: true
      t.integer :kind, null: false
      t.string :zip_code
      t.index %i[number event_id], unique: true
    end
  end
end
