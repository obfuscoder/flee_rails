# frozen_string_literal: true

require 'rails_helper'

RSpec.describe StockItem do
  subject(:stock_item) { build :stock_item }

  it { is_expected.to be_valid }

  it { is_expected.to belong_to :client }
  it { is_expected.to have_many(:events).through(:sold_stock_items) }

  it { is_expected.to validate_presence_of :client }
  it { is_expected.to validate_presence_of :description }
  it { is_expected.to validate_presence_of :price }
  it { is_expected.to validate_presence_of :number }
  it { is_expected.to validate_presence_of :code }
  it { is_expected.to validate_numericality_of(:price).is_greater_than(0) }
  it { is_expected.to validate_numericality_of(:number).is_greater_than(0) }
  it { is_expected.to validate_uniqueness_of(:number).scoped_to(:client_id) }

  its(:number) { is_expected.to eq 1 }
  its(:code) { is_expected.to eq '16' }
end
