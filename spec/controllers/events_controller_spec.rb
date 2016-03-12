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
    before do
      expect_any_instance_of(Event).to receive(:items_per_category).and_return([['Cat1', 3], ['Cat2', 2]])
      Timecop.travel event.shopping_periods.last.max + 1.day do
        get :items_per_category, id: event.id
      end
    end

    describe 'response' do
      subject { response }
      it { is_expected.to have_http_status :ok }
      its(:content_type) { is_expected.to eq 'application/json' }
      describe 'body' do
        subject { response.body }
        it { is_expected.to eq '[["Cat1",3],["Cat2",2]]' }
      end
    end
  end

  describe 'GET sold_items_per_category' do
    before do
      expect_any_instance_of(Event).to receive(:sold_items_per_category).and_return([['Cat1', 3], ['Cat2', 2]])
      Timecop.travel event.shopping_periods.last.max + 1.day do
        get :sold_items_per_category, id: event.id
      end
    end

    describe 'response' do
      subject { response }
      it { is_expected.to have_http_status :ok }
      its(:content_type) { is_expected.to eq 'application/json' }
      describe 'body' do
        subject { response.body }
        it { is_expected.to eq '[["Cat1",3],["Cat2",2]]' }
      end
    end
  end

  describe 'GET sellers_per_city' do
    before do
      expect_any_instance_of(Event).to receive(:sellers_per_zip_code).and_return(
        [
          double(zip_code: '75203', count: 3),
          double(zip_code: '71229', count: 2),
          double(zip_code: '76131', count: 1),
          double(zip_code: '76139', count: 1)
        ])
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
        it { is_expected.to eq [['Königsbach-Stein', 3], ['Leonberg', 2], ['Karlsruhe', 2]] }
      end
    end
  end
end
