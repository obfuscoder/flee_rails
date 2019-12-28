require 'rails_helper'

RSpec.describe StockLabelDecorator do
  subject { described_class.new stock_item }

  let(:stock_item) { build :stock_item, price: 8.9 }

  its(:number) { is_expected.to eq stock_item.number.to_s }
  its(:price) { is_expected.to eq '8,90 €' }
  its(:details) { is_expected.to eq stock_item.description }
  its(:code) { is_expected.to eq stock_item.code }
  its(:donation?) { is_expected.to be false }
  its(:reservation) { is_expected.to eq nil }
end
