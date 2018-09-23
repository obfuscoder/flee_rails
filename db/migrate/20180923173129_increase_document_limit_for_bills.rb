class IncreaseDocumentLimitForBills < ActiveRecord::Migration
  def change
    change_column :bills, :document, :binary, limit: 1000000
  end
end
