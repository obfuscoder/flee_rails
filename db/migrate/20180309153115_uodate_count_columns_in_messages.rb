# frozen_string_literal: true

class UodateCountColumnsInMessages < ActiveRecord::Migration
  def change
    rename_column :messages, :count, :scheduled_count
    add_column :messages, :sent_count, :integer
  end
end
