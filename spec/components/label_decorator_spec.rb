require 'rails_helper'

RSpec.describe LabelDecorator do
  subject { described_class.new item }

  let(:category) { create :category }
  let(:item) { create :item_with_code, category: category }

  its(:reservation) { is_expected.to eq item.reservation.number.to_s }
  its(:number) { is_expected.to eq item.number.to_s }
  its(:price) { is_expected.to eq '1,90 €' }
  its(:details) { is_expected.to eq "#{item.category}\n#{item.description}" }
  its(:code) { is_expected.to eq item.code }
  its(:donation?) { is_expected.to be false }

  context 'when item has empty size' do
    let(:item) { create :item_with_code, size: '' }

    its(:details) { is_expected.to eq "#{item.category}\n#{item.description}" }
  end

  context 'when item size is given' do
    let(:item) { create :item_with_code, size: '6' }

    its(:details) { is_expected.to eq "#{item.category}\n#{item.description}\n<strong>Größe: 6</strong>" }
  end

  its(:gender?) { is_expected.to eq false }

  context 'when category has gender enabled' do
    let(:category) { create :category, gender: true }
    let(:item) { create :item_with_code, category: category, gender: :female }

    its(:gender?) { is_expected.to eq true }
    its(:gender) { is_expected.to eq :female }
  end
end
