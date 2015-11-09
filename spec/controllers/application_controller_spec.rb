require 'rails_helper'

RSpec.describe ApplicationController do
  describe '#create_label_document' do
    controller do
      def create(items)
        create_label_document(items)
      end
    end

    let!(:items) { create_list :item, 5 }
    let(:preparations) {}
    before do
      preparations
      subject.create Item.all
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
      let(:preparations) { allow(Settings.brands.default).to receive(:prefix) { prefix } }

      it 'generates item codes with prefix' do
        items.each do |item|
          expect(item.reload.code).to start_with prefix
        end
      end
    end
  end
end
