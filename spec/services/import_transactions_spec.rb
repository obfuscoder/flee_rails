# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ImportTransactions do
  subject(:instance) { described_class.new event }
  let(:event) { double :event }
  describe '#call' do
    subject(:action) { instance.call transactions }
    let(:transaction1) { double :transaction1 }
    let(:transaction2) { double :transaction2 }
    let(:transactions) { %i[transaction1 transaction2] }
    let(:count) { transactions.count }
    before { allow(ImportTransactionJob).to receive :perform_later }
    it { is_expected.to eq count }
    it 'calls ImportTransctionJob with each transaction' do
      action
      transactions.each do |transaction|
        expect(ImportTransactionJob).to have_received(:perform_later).with event, transaction
      end
    end
  end
end
