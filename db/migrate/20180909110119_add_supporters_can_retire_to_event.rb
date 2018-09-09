# frozen_string_literal: true

class AddSupportersCanRetireToEvent < ActiveRecord::Migration
  def change
    add_column :events, :supporters_can_retire, :boolean
  end
end
