# frozen_string_literal: true

require 'rails_helper'

RSpec.describe BillDocument do
  subject(:document) { BillDocument.new }
  describe '#render' do
    let(:output) { PDF::Inspector::Text.analyze(document.render).strings }
    it 'contains generates proper bill with all fees'
  end
end
