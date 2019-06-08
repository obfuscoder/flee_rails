# frozen_string_literal: true

class AddGenderToCategory < ActiveRecord::Migration
  def change
    add_column :categories, :gender, :boolean
  end
end
