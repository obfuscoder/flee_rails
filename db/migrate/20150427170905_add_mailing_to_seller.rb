# frozen_string_literal: true

class AddMailingToSeller < ActiveRecord::Migration
  def change
    add_column :sellers, :mailing, :boolean
  end
end
