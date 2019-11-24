# frozen_string_literal: true

class AddPreciseBillAmountsToClients < ActiveRecord::Migration
  def change
    add_column :clients, :precise_bill_amounts, :boolean
  end
end
