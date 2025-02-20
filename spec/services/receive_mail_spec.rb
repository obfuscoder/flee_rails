require 'rails_helper'

RSpec.describe ReceiveMail do
  describe '#call' do
    subject(:action) { described_class.call(data) }

    let(:data) { double }
    let(:parsed_mail) { double }
    let(:mail) { double read_from_string: parsed_mail }
    let(:create_mail) { double call: result }
    let(:result) { double }

    before do
      allow(Mail).to receive(:read_from_string).with(data).and_return parsed_mail
      allow(CreateEmail).to receive(:new).with(parsed_mail).and_return create_mail
    end

    it { is_expected.to eq result }
  end
end
