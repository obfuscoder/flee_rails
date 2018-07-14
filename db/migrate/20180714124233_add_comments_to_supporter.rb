# frozen_string_literal: true

class AddCommentsToSupporter < ActiveRecord::Migration
  def change
    add_column :supporters, :comments, :string
  end
end
