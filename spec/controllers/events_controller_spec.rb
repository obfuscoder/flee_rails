# frozen_string_literal: true

require 'rails_helper'

RSpec.describe EventsController do
  let(:seller) { create :seller, zip_code: '04720' }
  let(:event) { create :event_with_ongoing_reservation }
  let!(:reservation) { create :reservation, seller: seller, event: event }

  before { session[:seller_id] = seller.id }

  describe 'GET show' do
    context 'when event belongs to other client' do
      let(:event) { create :event_with_ongoing_reservation, client: create(:client) }
      it 'throws exception' do
        expect { get :show, id: event.id }.to raise_error ActiveRecord::RecordNotFound
      end
    end

    context 'when event belongs to current client' do
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

      describe '@event' do
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
