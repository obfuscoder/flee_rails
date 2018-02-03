# frozen_string_literal: true

class CreateReviews < ActiveRecord::Migration
  def change
    create_table :reviews do |t|
      t.timestamps null: false

      t.references :event, index: true
      t.references :seller, index: true
    end
  end
end
