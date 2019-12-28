require 'rails_helper'

RSpec.describe CreateLabelDocument do
  subject(:action) { described_class.new(client, items).call }

  let(:reservation) { create :reservation }
  let(:client) { Client.first }
  let(:items) { create_list :item, 5, reservation: reservation }
  let(:preparations) {}
  let(:document) { double render: nil }

  before do
    preparations
    allow(LabelDocument).to receive(:new).and_return document
    action
  end

  it 'generates label documents' do
    expect(LabelDocument).to have_received(:new).with(have_exactly(items.count).items)
    expect(document).to have_received(:render)
  end

  context 'when item count exceeds category limit' do
    let(:category) { create :category, max_items_per_seller: 5 }
    let(:items) { create_list :item, 5, category: category, reservation: reservation }

    it 'generates item numbers and codes' do
      items.each do |item|
        item.reload
        expect(item.code).to be_present
        expect(item.number).to be_present
      end
    end
  end

  it 'generates item numbers and codes' do
    items.each do |item|
      item.reload
      expect(item.code).to be_present
      expect(item.number).to be_present
    end
  end

  it 'generates item codes with client prefix' do
    items.each do |item|
      expect(item.reload.code).to start_with client.prefix
    end
  end
end
