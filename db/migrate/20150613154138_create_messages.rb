# frozen_string_literal: true

class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.timestamps null: false

      t.string :category
      t.references :event, index: true, foreign_key: true
    end

    add_index :messages, %i[category event_id], unique: true
  end
end
