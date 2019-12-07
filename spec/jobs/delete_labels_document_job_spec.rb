# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DeleteLabelsDocumentJob do
  subject(:action) { described_class.perform_now event }

  let(:event) { double }
  let(:service) { double call: nil }

  before do
    allow(DeleteLabelDocumentFiles).to receive(:new).and_return(service)
    action
  end

  it 'calls the delete service' do
    expect(DeleteLabelDocumentFiles).to have_received(:new).with(event)
    expect(service).to have_received(:call)
  end
end
