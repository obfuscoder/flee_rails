# frozen_string_literal: true

require 'rails_helper'

module Admin
  RSpec.describe ReservationsController do
    include Sorcery::TestHelpers::Rails::Controller
    let(:user) { create :user }
    before { login_user user }

    let(:seller1) { create :seller, first_name: 'AAAAA', last_name: 'BBBB', email: 'zzz@bbb.de' }
    let(:seller2) { create :seller, first_name: 'ZZZZZ', last_name: 'EEEE', email: 'bbb@bbb.de' }
    let(:seller3) { create :seller, first_name: 'BBBBB', last_name: 'BBBB', email: 'aaa@bbb.de' }
    let(:sellers) { [seller1, seller2, seller3] }
    let(:event) { create :event_with_ongoing_reservation }
    let!(:reservations) { sellers.map { |seller| create :reservation, event: event, seller: seller } }

    describe 'GET index' do
      let(:index_params) { { event_id: event.id }.merge params }
      let(:params) { {} }
      before { get :index, index_params }

      its(:searchable?) { is_expected.to eq true }

      describe '@reservations' do
        subject { assigns :reservations }
        its(:first) { is_expected.to eq reservations[0] }

        context 'when search parameter is given' do
          let(:params) { { search: 'bbbb' } }
          its(:count) { is_expected.to eq 2 }
        end

        context 'when sort parameter is set to email' do
          let(:params) { { sort: 'sellers.email' } }
          its(:first) { is_expected.to eq reservations[2] }
        end

        context 'when sort parameter is set to name' do
          let(:params) { { sort: 'sellers.name' } }
          its(:first) { is_expected.to eq reservations[0] }
        end

        context 'when direction parameter is set to desc' do
          context 'when sort parameter is set to email' do
            let(:params) { { sort: 'sellers.email', dir: 'desc' } }
            its(:first) { is_expected.to eq reservations[0] }
          end

          context 'when sort parameter is set to name' do
            let(:params) { { sort: 'sellers.name', dir: 'desc' } }
            its(:first) { is_expected.to eq reservations[1] }
          end
        end
      end
    end

    describe 'POST create' do
      let(:action) { post :create, event_id: event.id, reservation: { seller_id: [seller1.id, seller2.id] } }
      let(:reservation) { create :reservation }

      before do
        creator = double
        expect(creator).to receive(:create).with(instance_of(Event), instance_of(Seller),
                                                 hash_including(context: :admin)).twice.and_return reservation
        expect(CreateReservation).to receive(:new).and_return creator
        action
      end

      it { is_expected.to redirect_to admin_event_reservations_path }
      it 'notifies about the reservations' do
        expect(flash[:notice]).to be_present
      end

      context 'when reservations were not persisted' do
        let(:reservation) { build :reservation }
        it { is_expected.to redirect_to admin_event_reservations_path }
        it 'notifies about the reservations count' do
          expect(flash[:notice]).to be_present
        end
      end
    end

    describe 'GET edit' do
      let(:reservation) { create :reservation }
      let(:action) { get :edit, event_id: reservation.event.id, id: reservation.id }
      before { action }
      describe 'response' do
        subject { response }
        it { is_expected.to render_template :edit }
        it { is_expected.to have_http_status :ok }
      end
      describe '@reservation' do
        subject { assigns :reservation }
        it { is_expected.to eq reservation }
      end
    end

    describe 'PUT update' do
      let(:reservation) { create :reservation }
      let(:event) { reservation.event }
      let(:params) { { fee: '2.5', commission_rate: '0.7', max_items: '42', category_limits_ignored: true } }
      before { put :update, event_id: event.id, id: reservation.id, reservation: params }

      it 'redirects to index path' do
        expect(response).to redirect_to admin_event_reservations_path
      end

      it 'stores fee and commission rate' do
        expect(reservation.reload.fee).to eq 2.5
        expect(reservation.reload.commission_rate).to eq 0.7
      end

      it 'stores max items' do
        expect(reservation.reload.max_items).to eq 42
      end

      it 'stores category limits ignored' do
        expect(reservation.reload.category_limits_ignored).to eq true
      end
    end
  end
end
