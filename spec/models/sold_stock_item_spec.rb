require 'rails_helper'

RSpec.describe SoldStockItem do
  subject(:sold_stock_item) { build :sold_stock_item }

  it { is_expected.to belong_to(:event) }
  it { is_expected.to belong_to(:stock_item) }

  it { is_expected.to be_valid }

  it { is_expected.to validate_presence_of(:event) }
  it { is_expected.to validate_presence_of(:stock_item) }
  it { is_expected.to validate_presence_of(:amount) }
  it { is_expected.to validate_numericality_of(:amount).is_greater_than(0) }
  it { is_expected.to validate_uniqueness_of(:event_id).scoped_to(:stock_item_id) }
end
