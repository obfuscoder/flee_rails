require 'rails_helper'

RSpec.describe LabelDocument do
  let(:details) { 'Schuhe\nweiß\nGröße 10' }
  let(:label) { double number: '12-34', price: '€ 2,90', details: details, code: '91020120348' }
  let(:labels) { [label] }
  subject(:document) { LabelDocument.new labels }
  describe '#render' do
    let(:output) { PDF::Inspector::Text.analyze(document.render).strings }
    it 'contains label information' do
      expect(output).to include label.number
      expect(output).to include label.price
      expect(output).to include label.details
      expect(output).to include label.code
    end

    context 'with characters outside of ascii range in details' do
      let(:details) { '丙' }
      it 'generates pdf without errors' do
        expect(output).to include details
      end
    end
  end
end