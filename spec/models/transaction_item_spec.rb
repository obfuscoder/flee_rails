require 'rails_helper'

RSpec.describe TransactionItem do
  subject(:transaction_item) { build :transaction_item }

  it { is_expected.to be_valid }
  it { is_expected.to belong_to :item }
  it { is_expected.to belong_to :item_transaction }
  it { is_expected.to validate_presence_of :item }
  it { is_expected.to validate_presence_of :item_transaction }
  it { is_expected.to validate_uniqueness_of(:item).scoped_to(:transaction_id) }
end
