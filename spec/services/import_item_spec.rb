# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ImportItem do
  subject(:instance) { described_class.new item }

  let(:seller) { create :seller }
  let(:reservation) { create :reservation, seller: seller }
  let(:item) { create :item, reservation: reservation }

  describe '#call' do
    subject(:action) { instance.call other_reservation }

    let(:other_reservation) { create :reservation, seller: seller, number: 10 }

    it { is_expected.to be_a Item }

    its(:description) { is_expected.to eq item.description }
    its(:category) { is_expected.to eq item.category }
    its(:size) { is_expected.to eq item.size }
    its(:price) { is_expected.to eq item.price }
    its(:reservation) { is_expected.to eq other_reservation }
    its(:code) { is_expected.to eq nil }
    its(:number) { is_expected.to eq nil }
    it { is_expected.to be_persisted }

    context 'when reservation is for different seller' do
      let(:other_seller) { create :seller }
      let(:reservation) { create :reservation, seller: other_seller }

      it { expect { action }.to raise_error StandardError }
    end

    context 'when item has code' do
      let(:item) { create :item_with_code, reservation: reservation }

      its(:code) { is_expected.to eq nil }
      it { is_expected.to be_persisted }

      context 'when client#import_item_code_enabled' do
        before { Client.first.update import_item_code_enabled: true }

        its(:code) { is_expected.to eq nil }
        it { is_expected.to be_persisted }

        context 'when reservation numbers are equal' do
          let(:other_reservation) { create :reservation, seller: seller, number: reservation.number }

          its(:code) { is_expected.to eq item.code }
          it { is_expected.to be_persisted }

          context 'when reservation already has item with that code' do
            before { create :item, code: item.code, reservation: other_reservation }

            its(:code) { is_expected.to eq nil }
            it { is_expected.to be_persisted }
          end
        end
      end
    end
  end
end
