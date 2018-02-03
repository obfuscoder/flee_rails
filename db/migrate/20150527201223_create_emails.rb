# frozen_string_literal: true

class CreateEmails < ActiveRecord::Migration
  def change
    create_table :emails do |t|
      t.timestamps null: false

      t.references :seller, index: true, foreign_key: true
      t.string :to
      t.string :subject
      t.text :body
      t.boolean :sent
    end
  end
end
