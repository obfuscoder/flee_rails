# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Message do
  subject(:message) { build :message }

  it { is_expected.to belong_to :event }
  it { is_expected.to be_valid }
  it { is_expected.to validate_uniqueness_of(:category).scoped_to(:event_id) }

  describe '#sent' do
    subject(:action) { message.sent }
    it { is_expected.to eq true }

    it 'stores increased sent_count' do
      action
      expect(message.sent_count).to eq 1
      expect(message).to be_persisted
    end

    context 'when sent_count is 5' do
      let(:message) { build :message, sent_count: 5 }
      it { is_expected.to eq true }

      it 'stores increased sent_count' do
        action
        expect(message.sent_count).to eq 6
        expect(message).to be_persisted
      end
    end
  end
end
