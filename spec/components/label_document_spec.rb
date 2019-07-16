# frozen_string_literal: true

require 'rails_helper'

RSpec.describe LabelDocument do
  subject(:document) { described_class.new labels }

  let(:details) { 'Schuhe\nweiß\nGröße 10' }
  let(:label) do
    double :label, reservation: '12', number: '34', gender?: false,
                   price: '€ 2,90', details: details, code: '91020120348', donation?: donation
  end
  let(:stock_label) do
    double :label, reservation: nil, number: '47', gender?: false,
           price: '€ 2,10', details: 'Tasche', code: '4711', donation?: false
  end
  let(:labels) { [label, stock_label] }
  let(:donation) { true }

  describe '#render' do
    let(:output) { PDF::Inspector::Text.analyze(document.render).strings }

    it 'contains label information' do
      expect(output).to include label.reservation
      expect(output).to include label.number
      expect(output).to include label.price
      expect(output).to include label.details
      expect(output).to include label.code
      expect(output).to include 'S'
    end

    it 'contains stock label information' do
      expect(output).to include stock_label.number
      expect(output).to include stock_label.price
      expect(output).to include stock_label.details
      expect(output).to include stock_label.code
    end

    context 'with characters outside of ascii range in details' do
      let(:details) { '丙' }

      it 'generates pdf without errors' do
        expect(output).to include details
      end
    end
  end
end
