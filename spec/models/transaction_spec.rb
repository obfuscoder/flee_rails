require 'rails_helper'

RSpec.describe Transaction do
  subject(:transaction) { build :transaction }

  it { is_expected.to be_valid }
  it { is_expected.to belong_to :event }
  it { is_expected.to validate_presence_of :event }
  it { is_expected.to validate_presence_of :kind }
  it { is_expected.to validate_presence_of :number }
  it { is_expected.to validate_uniqueness_of(:number).scoped_to(:event_id) }
  it { is_expected.to have_many(:transaction_items).dependent(:delete_all) }
  it { is_expected.to have_many(:items).through(:transaction_items) }
  it { is_expected.to have_many(:transaction_stock_items).dependent(:delete_all) }
  it { is_expected.to have_many(:stock_items).through(:transaction_stock_items) }
end
