# frozen_string_literal: true

require 'rails_helper'

module Admin
  RSpec.describe MessagesController do
    include Sorcery::TestHelpers::Rails::Controller
    before { login_user create(:user) }

    describe 'POST :invitation' do
      subject(:action) { post :invitation, event_id: event.id }
      let(:event) { create :event }
      let(:count) { 3 }
      before do
        allow(SendInvitation).to receive(:new).and_return(double(call: count))
        action
      end

      it 'sends invitation' do
        expect(SendInvitation).to have_received(:new).with event
      end

      describe 'response' do
        subject { response }

        it { is_expected.to redirect_to admin_event_path(event) }
      end
    end

    describe 'POST :reservation_closing' do
      subject(:action) { post :reservation_closing, event_id: event.id }
      let(:event) { create :event_with_ongoing_reservation }
      let!(:reservations) { create_list :reservation, 5, event: event }

      before do
        allow(SellerMailer).to receive(:reservation_closing).and_return(double(deliver_now: nil))
        event.reload
        action
      end

      it 'sends mail to all reservations' do
        expect(SellerMailer).to have_received(:reservation_closing).with(instance_of(Reservation))
                                                                   .exactly(reservations.count).times
      end

      describe 'response' do
        subject { response }
        it { is_expected.to redirect_to admin_event_path(event) }
      end
    end

    describe 'POST :reservation_closed' do
      subject(:action) { post :reservation_closed, event_id: event.id }
      let(:event) { create :event_with_ongoing_reservation }
      let!(:reservations) { create_list :reservation, 5, event: event }

      before do
        allow(SellerMailer).to receive(:reservation_closed).and_return(double(deliver_now: nil))
        event.reload
        action
      end

      it 'sends mail to all reservations' do
        expect(SellerMailer).to have_received(:reservation_closed).with(instance_of(Reservation))
                                                                  .exactly(reservations.count).times
      end

      describe 'response' do
        subject { response }
        it { is_expected.to redirect_to admin_event_path(event) }
      end
    end

    describe 'POST :finished' do
      subject(:action) { post :finished, event_id: event.id }
      let(:event) { create :event_with_ongoing_reservation }
      let!(:reservations) { create_list :reservation, 5, event: event }

      before do
        allow(SellerMailer).to receive(:finished).and_return(double(deliver_now: nil))
        event.reload
        action
      end

      it 'sends mail to all reservations' do
        expect(SellerMailer).to have_received(:finished).with(instance_of(Reservation))
                                                        .exactly(reservations.count).times
      end

      describe 'response' do
        subject { response }
        it { is_expected.to redirect_to admin_event_path(event) }
      end
    end
  end
end
