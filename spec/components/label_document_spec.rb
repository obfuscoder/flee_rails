# frozen_string_literal: true

require 'rails_helper'

RSpec.describe LabelDocument do
  subject(:document) { described_class.new labels }

  let(:details) { 'Schuhe\nweiß\nGröße 10' }
  let(:label) do
    double :label, reservation: '12', number: '34',
                   price: '€ 2,90', details: details, code: '91020120348', donation?: donation
  end
  let(:labels) { [label] }
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

    context 'with characters outside of ascii range in details' do
      let(:details) { '丙' }

      it 'generates pdf without errors' do
        expect(output).to include details
      end
    end
  end
end
