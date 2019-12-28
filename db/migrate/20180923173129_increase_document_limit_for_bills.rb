class IncreaseDocumentLimitForBills < ActiveRecord::Migration
  def change
    change_column :bills, :document, :binary, limit: 1_000_000
  end
end
