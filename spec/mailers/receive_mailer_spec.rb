# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ReceiveMailer do
  describe '#receive' do
    subject(:action) { described_class.receive(mail) }

    let(:mail) { double }
    let(:create_mail) { double call: result }
    let(:result) { double }

    before { allow(CreateEmail).to receive(:new).and_return create_mail }

    it { is_expected.to eq result }
  end
end
