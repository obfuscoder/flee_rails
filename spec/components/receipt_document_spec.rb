require 'rails_helper'

RSpec.describe ReceiptDocument do
  let(:event) { FactoryGirl.create :event_with_ongoing_reservation, donation_of_unsold_items_enabled: true }
  let(:reservation) { FactoryGirl.create :reservation, event: event }
  let!(:sold_items) { FactoryGirl.create_list :item_with_code, 21, reservation: reservation, sold: Time.now }
  let!(:returned_items) { FactoryGirl.create_list :item_with_code, 12, reservation: reservation }
  let!(:donated_items) { FactoryGirl.create_list :item_with_code, 5, reservation: reservation, donation: true }
  let(:receipt) { Receipt.new reservation.reload }
  subject(:document) { ReceiptDocument.new receipt }
  describe '#render' do
    let(:output) { PDF::Inspector::Text.analyze(document.render).strings }
    it 'contains seller address' do
      expect(output).to include reservation.seller.name
      expect(output).to include reservation.seller.street
      expect(output).to include "#{reservation.seller.zip_code} #{reservation.seller.city}"
      expect(output).to include '21 Artikel wurde(n) verkauft'
      expect(output).to include '12 Artikel wurde(n) zurückgegeben'
      expect(output).to include '5 Artikel wurde(n) gespendet'
      expect(output).to include 'Reservierungsnummer: 1'
    end
    it 'creates file' do
      File.open('receipt.pdf', 'wb') { |file| file.write document.render }
    end
  end
end
