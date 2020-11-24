class AddPreciseBillAmountsToClients < ActiveRecord::Migration[4.2]
  def change
    add_column :clients, :precise_bill_amounts, :boolean
  end
end
