class AddPreciseBillAmountsToEvents < ActiveRecord::Migration[4.2]
  def change
    add_column :events, :precise_bill_amounts, :boolean
  end
end
