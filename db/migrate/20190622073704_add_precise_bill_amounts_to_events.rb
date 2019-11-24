# frozen_string_literal: true

class AddPreciseBillAmountsToEvents < ActiveRecord::Migration
  def change
    add_column :events, :precise_bill_amounts, :boolean
  end
end
