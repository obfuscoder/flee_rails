class IncreaseDocumentLimitForBills < ActiveRecord::Migration[4.2]
  def change
    change_column :bills, :document, :binary, limit: 1_000_000
  end
end
