# frozen_string_literal: true

require 'rails_helper'

RSpec.describe LabelDecorator do
  subject { LabelDecorator.new item }
  let(:item) { create :item_with_code }
  its(:number) { is_expected.to eq "#{item.reservation.number} - #{item.number}" }
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
end
