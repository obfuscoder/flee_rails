require 'rails_helper'

RSpec.describe TransactionStockItem do
  subject(:transaction_stock_item) { build :transaction_stock_item }

  it { is_expected.to be_valid }
  it { is_expected.to belong_to :stock_item }
  it { is_expected.to belong_to :item_transaction }
  it { is_expected.to validate_presence_of :stock_item }
  it { is_expected.to validate_presence_of :item_transaction }
  it { is_expected.to validate_presence_of :amount }
  it { is_expected.to validate_uniqueness_of(:stock_item).scoped_to(:transaction_id) }
  it { is_expected.to validate_numericality_of(:amount).is_greater_than(0) }
end
