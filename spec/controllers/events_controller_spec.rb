require 'rails_helper'

RSpec.describe EventsController do
  let(:seller) { create :seller }
  let(:reservation) { create :reservation, seller: seller }
  let(:event) { reservation.event }

  before { session[:seller_id] = seller.id }

  describe 'GET top_sellers' do
    let!(:reservation1) { create :reservation, event: event }
    let!(:reservation2) { create :reservation, event: event }
    let!(:items1) { create_list :sold_item, 3, reservation: reservation1 }
    let!(:items2) { create_list :sold_item, 2, reservation: reservation2 }
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
        it { is_expected.to include reservation1.number.to_s => 3, reservation2.number.to_s => 2 }
      end
    end
  end
end
