# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ApplicationController do
  describe '#create_label_document' do
    controller do
      def create_labels(items)
        create_label_document(items)
      end
    end

    let(:items) { create_list :item, 5 }
    let(:preparations) {}
    before do
      items
      preparations
      subject.create_labels Item.all
    end

    context 'when item count exceeds category limit' do
      let(:category) { create :category, max_items_per_seller: 5 }
      let(:reservation) { create :reservation }
      let(:items) { create_list :item, 5, category: category, reservation: reservation }
      let(:preparations) { category.update max_items_per_seller: 3 }

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

    context 'with prefix configured' do
      let(:prefix) { 'ABC' }
      let(:preparations) { allow(Settings.brands.demo).to receive(:prefix) { prefix } }

      it 'generates item codes with prefix' do
        items.each do |item|
          expect(item.reload.code).to start_with prefix
        end
      end
    end
  end
end
