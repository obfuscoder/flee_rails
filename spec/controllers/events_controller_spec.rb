require 'rails_helper'

RSpec.describe EventsController do
  let(:seller) { create :seller, zip_code: '04720' }
  let(:reservation) { create :reservation, seller: seller }
  let(:event) { reservation.event }

  before { session[:seller_id] = seller.id }

  describe 'GET show' do
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

  describe 'GET items_per_category' do
    let!(:items) { create_list :item, 3, reservation: reservation }
    let!(:sold_items) { create_list :sold_item, 2, reservation: reservation }
    before do
      Timecop.travel event.shopping_periods.last.max + 1.day do
        get :items_per_category, id: event.id
      end
    end

    describe 'response' do
      subject { response }
      it { is_expected.to have_http_status :ok }
      its(:content_type) { is_expected.to eq 'application/json' }
      describe 'body' do
        subject { JSON.parse response.body }
        it { is_expected.to eq((items + sold_items).map { |i| [i.category.name, 1] }) }
      end
    end
  end

  describe 'GET sold_items_per_category' do
    let!(:items) { create_list :item, 3, reservation: reservation }
    let!(:sold_items) { create_list :sold_item, 2, reservation: reservation }
    before do
      Timecop.travel event.shopping_periods.last.max + 1.day do
        get :sold_items_per_category, id: event.id
      end
    end

    describe 'response' do
      subject { response }
      it { is_expected.to have_http_status :ok }
      its(:content_type) { is_expected.to eq 'application/json' }
      describe 'body' do
        subject { JSON.parse response.body }
        it { is_expected.to eq sold_items.map { |i| [i.category.name, 1] } }
      end
    end
  end

  describe 'GET sellers_per_city' do
    let(:sellers_city1) { create_list :seller, 3, zip_code: '75203' }
    let(:sellers_city2) { create_list :seller, 2, zip_code: '71229' }
    let(:sellers) { sellers_city1 + sellers_city2 }
    let!(:reservations) { sellers.map { |seller| create :reservation, event: event, seller: seller } }
    before do
      Timecop.travel event.shopping_periods.last.max + 1.day do
        get :sellers_per_city, id: event.id
      end
    end

    describe 'response' do
      subject { response }
      it { is_expected.to have_http_status :ok }
      its(:content_type) { is_expected.to eq 'application/json' }
      describe 'body' do
        subject { JSON.parse response.body }
        it { is_expected.to eq [['Königsbach-Stein', 3], ['Leonberg', 2], ['Döbeln', 1]] }

        context 'when several zip codes map to same city' do
          let(:seller1_city3) { create :seller, zip_code: '76131' }
          let(:seller2_city3) { create :seller, zip_code: '76139' }
          let(:sellers) { sellers_city1 + sellers_city2 << seller1_city3 << seller2_city3 }
          it { is_expected.to eq [['Königsbach-Stein', 3], ['Leonberg', 2], ['Karlsruhe', 2], ['Döbeln', 1]] }
        end
      end
    end
  end
end
