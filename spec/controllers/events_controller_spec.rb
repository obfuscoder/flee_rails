require 'rails_helper'

RSpec.describe EventsController do
  let(:seller) { create :seller }
  let(:reservation) { create :reservation, seller: seller }
  let(:event) { reservation.event }

  before { session[:seller_id] = seller.id }

  describe 'GET show' do
    let!(:items) { create_list :item, 5, reservation: reservation }
    let!(:sold_items) { create_list :sold_item, 3, reservation: reservation }
    before do
      Timecop.travel event.shopping_periods.last.max + 1.day do
        get :show, id: event.id
      end
    end
    describe 'response' do
      subject { response }
      it { is_expected.to render_template :show }
      it { is_expected.to have_http_status :ok }
    end

    describe 'assigns' do
      describe 'event' do
        subject { assigns :event }
        it { is_expected.to eq event }
      end

      describe 'item_count' do
        subject { assigns :item_count }
        it { is_expected.to eq 8 }
      end

      describe 'sold_item_count' do
        subject { assigns :sold_item_count }
        it { is_expected.to eq 3 }
      end
    end
  end

  describe 'GET top_sellers' do
    let!(:reservation1) { create :reservation, event: event }
    let!(:reservation2) { create :reservation, event: event }
    let!(:items1) { create_list :sold_item, 3, reservation: reservation1 }
    let!(:items2) { create_list :sold_item, 2, reservation: reservation2 }
    let!(:unsold_items) { create_list :item, 2, reservation: reservation2 }
    before do
      Timecop.travel event.shopping_periods.last.max + 1.day do
        get :top_sellers, id: event.id
      end
    end

    describe 'response' do
      subject { response }
      it { is_expected.to have_http_status :ok }
      its(:content_type) { is_expected.to eq 'application/json' }
      describe 'body' do
        subject { JSON.parse response.body }
        it { is_expected.to eq [[reservation1.number, 3], [reservation2.number, 2]] }
      end
    end
  end
end
