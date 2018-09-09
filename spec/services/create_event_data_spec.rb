# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CreateEventData do
  subject(:instance) { described_class.new client }

  let(:client) { Client.first }
  let!(:categories) { create_list :category, 7 }
  let!(:stock_items) { create_list :stock_item, 4 }

  describe '#call' do
    subject(:action) { instance.call event }

    let(:event) { create :event_with_ongoing_reservation }
    let!(:reservations) { create_list :reservation, 2, event: event }
    let!(:items1) { create_list :item_with_code, 3, reservation: reservations.first, category: categories.first }
    let!(:items2) { create_list :item_with_code, 2, reservation: reservations.second, category: categories.second }
    let!(:items_without_code) { create_list :item, 2, reservation: reservations.second, category: categories.last }
    let!(:sold_stock_items) { event.sold_stock_items.create stock_item: stock_items.first, amount: 2 }

    before { event.reload }

    describe 'decoded output' do
      subject(:json) { JSON.parse ActiveSupport::Gzip.decompress(action), symbolize_names: true }

      it do
        is_expected.to include :id, :name, :price_precision, :commission_rate, :reservation_fee,
                               :donation_of_unsold_items_enabled, :reservation_fees_payed_in_advance
      end
      it { is_expected.to include :categories, :sellers, :items, :reservations, :stock_items }

      describe '[:stock_items]' do
        subject { json[:stock_items] }

        it { is_expected.to have(4).items }
        it { is_expected.to all(include(:description, :price, :number, :code, :sold)) }
        its(:first) { is_expected.to include sold: 2 }
      end

      its([:categories]) { is_expected.to have(7).items }
      its([:categories]) { is_expected.to all(include(:id, :name)) }

      its([:sellers]) { is_expected.to have(2).items }
      its([:sellers]) do
        is_expected.to all(include(:id, :first_name, :last_name, :street, :zip_code, :city, :phone, :email))
      end

      its([:reservations]) { is_expected.to have(2).items }
      its([:reservations]) { is_expected.to all(include(:id, :number, :seller_id, :fee, :commission_rate)) }

      its([:items]) { is_expected.to have(5).items }
      its([:items]) do
        is_expected.to all(include(:id, :category_id, :reservation_id, :description,
                                   :number, :code, :sold, :donation, :size, :price))
      end
    end
  end
end
