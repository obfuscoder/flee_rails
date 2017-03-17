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

  describe 'GET review' do
    before do
      Timecop.travel event.shopping_periods.last.max + 1.day do
        get :review, id: event.id
      end
    end
    describe 'response' do
      subject { response }
      it { is_expected.to redirect_to new_event_reservation_review_path(event, reservation) }
    end
  end

  describe 'GET reserve' do
    before { get :reserve, id: event.id }
    describe 'response' do
      subject { response }
      it { is_expected.to redirect_to event_reservations_create_path(event) }
    end
  end
end
