require 'rails_helper'

RSpec.describe SuspensionsQuery do
  subject(:instance) { described_class.new event }

  let(:event) { create :event }

  describe '#search' do
    subject(:action) { instance.search needle, page, order }

    let!(:item_with_needle_in_reason) { create :suspension, event: event, reason: "reason with #{needle}" }
    let(:seller_with_needle_in_name) { create :seller, first_name: "name with #{needle}" }
    let!(:item_with_needle_in_seller_name) { create :suspension, event: event, seller: seller_with_needle_in_name }
    let(:page) { nil }
    let(:order) { nil }
    let(:needle) { 'needle' }

    it { is_expected.to include item_with_needle_in_reason }
    it { is_expected.to include item_with_needle_in_seller_name }
  end

  describe '#suspensible_sellers' do
    subject(:action) { instance.suspensible_sellers }

    let!(:not_yet_suspended_seller) { create :seller }
    let!(:already_suspended_seller) { create :seller }
    let!(:suspension) { create :suspension, event: event, seller: already_suspended_seller }

    it { is_expected.to include not_yet_suspended_seller }
    it { is_expected.not_to include already_suspended_seller }
  end

  describe '#create' do
    subject(:action) { instance.create seller_ids, reason }

    let(:seller_ids) { [seller1.id, seller2.id] }
    let(:reason) { 'reason' }
    let(:seller1) { create :seller }
    let(:seller2) { create :seller }

    it { is_expected.to be_an Array }
    it { is_expected.to have(2).items }
    it { is_expected.to all(be_a(Suspension).and(be_persisted).and(be_valid)) }

    context 'when a suspension could not be saved' do
      let!(:suspension) { create :suspension, event: event, seller: seller2 }

      it { is_expected.to have(1).item }
      it { is_expected.to all(be_a(Suspension).and(be_persisted).and(be_valid)) }
    end
  end

  describe '#find' do
    subject(:action) { instance.find(suspension.id) }

    let(:suspension) { create :suspension, event: event }

    it { is_expected.to eq suspension }

    context 'when id belongs to suspension for a different event' do
      let(:suspension) { create :suspension }

      it 'raises error' do
        expect { action }.to raise_error ActiveRecord::RecordNotFound
      end
    end
  end
end
