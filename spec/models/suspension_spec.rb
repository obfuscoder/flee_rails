# frozen_string_literal: true

require 'rails_helper'

describe Suspension do
  subject(:instance) { build :suspension }

  it { is_expected.to belong_to(:event) }
  it { is_expected.to belong_to(:seller) }
  it { is_expected.to validate_uniqueness_of(:seller_id).scoped_to(:event_id) }
  it { is_expected.to validate_presence_of(:event) }
  it { is_expected.to validate_presence_of(:seller) }
  it { is_expected.to validate_presence_of(:reason) }
  it { is_expected.to be_valid }

  its(:reason) { is_expected.not_to be_nil }

  describe '#search' do
    subject(:action) { described_class.search needle }

    let!(:suspension) { create :suspension, reason: reason, seller: seller }
    let(:seller) { create :seller, first_name: first_name }
    let(:needle) { 'needle' }
    let(:reason) { 'reason' }
    let(:first_name) { 'first name' }

    context 'when reason contains needle' do
      let(:reason) { "foo #{needle} bar" }

      it { is_expected.to include suspension }
    end

    context 'when seller contains needle' do
      let(:first_name) { "foo #{needle} bar" }

      it { is_expected.to include suspension }
    end

    [nil, ''].each do |input|
      context "when needle is [#{input}" do
        let(:needle) { input }

        it { is_expected.to include suspension }
      end
    end
  end
end
