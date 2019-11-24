# frozen_string_literal: true

require 'rails_helper'

module Admin
  RSpec.describe ReservationsController do
    include Sorcery::TestHelpers::Rails::Controller
    let(:user) { create :user }
    let(:seller1) { create :seller, first_name: 'AAAAA', last_name: 'BBBB', email: 'zzz@bbb.de' }
    let(:seller2) { create :seller, first_name: 'ZZZZZ', last_name: 'EEEE', email: 'bbb@bbb.de' }
    let(:seller3) { create :seller, first_name: 'BBBBB', last_name: 'BBBB', email: 'aaa@bbb.de' }
    let(:sellers) { [seller1, seller2, seller3] }
    let(:event) { create :event_with_ongoing_reservation }
    let!(:reservations) { sellers.map { |seller| create :reservation, event: event, seller: seller } }

    before { login_user user }

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

    describe 'GET new' do
      let!(:new_seller) { create :seller }
      let(:preparations) {}

      before do
        preparations
        get :new, event_id: event.id
      end

      describe 'response' do
        subject { response }

        it { is_expected.to render_template :new }
        it { is_expected.to have_http_status :ok }
      end

      describe '@reservation' do
        subject { assigns :reservation }

        it { is_expected.to be_a_new Reservation }
      end

      describe '@sellers' do
        subject { assigns :sellers }

        it { is_expected.to include new_seller }

        context 'when reservation by seller is forbidden' do
          let(:preparations) { new_seller.client.update reservation_by_seller_forbidden: true }

          it { is_expected.to include new_seller }
        end
      end

      describe '@available_numbers' do
        subject { assigns :available_numbers }

        it { is_expected.not_to include 3 }
        it { is_expected.to include 5 }
      end
    end

    describe 'GET new_bulk' do
      let!(:new_seller) { create :seller }
      let(:preparations) {}

      before do
        preparations
        get :new_bulk, event_id: event.id
      end

      describe 'response' do
        subject { response }

        it { is_expected.to render_template :new_bulk }
        it { is_expected.to have_http_status :ok }
      end

      describe '@reservation' do
        subject { assigns :reservation }

        it { is_expected.to be_a_new Reservation }
      end

      describe '@sellers' do
        subject { assigns :sellers }

        it { is_expected.to include new_seller }

        context 'when reservation by seller is forbidden' do
          let(:preparations) { event.client.update reservation_by_seller_forbidden: true }

          it { is_expected.to include new_seller }
        end
      end
    end

    describe 'POST create' do
      let!(:new_seller) { create :seller }
      let(:number) { 5 }
      let(:commission_rate) { 0.4 }
      let(:fee) { 15 }
      let(:max_items) { 300 }
      let(:category_limits_ignored) { true }
      let(:reservation_param) do
        { seller_id: new_seller.id, number: number, commission_rate: commission_rate,
          category_limits_ignored: category_limits_ignored, max_items: max_items, fee: fee }
      end
      let(:action) { post :create, event_id: event.id, reservation: reservation_param }
      let(:reservation) { create :reservation, event: event, seller: new_seller, number: number }
      let(:creator) { double call: reservation }
      let(:preparations) {}
      let(:creation_checks) {}

      before do
        allow(CreateReservation).to receive(:new).and_return creator
        preparations
        action
      end

      it { is_expected.to redirect_to admin_event_reservations_path }

      it 'notifies about the reservation' do
        expect(flash[:notice]).to be_present
      end

      it 'uses CreateReservation' do
        expect(creator).to have_received(:call).with(have_attributes(number: number,
                                                                     commission_rate: commission_rate,
                                                                     fee: fee,
                                                                     max_items: max_items,
                                                                     category_limits_ignored: category_limits_ignored),
                                                     hash_including(context: :admin))
      end

      context 'when reservation could not be created' do
        let(:reservation) { event.reservations.create }

        describe 'response' do
          subject { response }

          it { is_expected.to render_template :new }
        end

        describe '@reservation' do
          subject { assigns :reservation }

          it { is_expected.to be_a_new Reservation }
        end

        describe '@sellers' do
          subject { assigns :sellers }

          it { is_expected.to include new_seller }
        end

        describe '@available_numbers' do
          subject { assigns :available_numbers }

          it { is_expected.to include number }
        end
      end
    end

    describe 'POST create_bulk' do
      let!(:new_seller) { create :seller }
      let!(:new_seller2) { create :seller }
      let(:reservation_param) { { seller_id: [new_seller.id, new_seller2.id] } }
      let(:action) { post :create_bulk, event_id: event.id, reservation: reservation_param }
      let(:reservation) { create :reservation }
      let(:creator) { double call: reservation }
      let(:preparations) {}

      before do
        allow(CreateReservation).to receive(:new).and_return creator
        preparations
        action
      end

      it { is_expected.to redirect_to admin_event_reservations_path }

      it 'notifies about the reservations' do
        expect(flash[:notice]).to be_present
      end

      it 'uses CreateReservation' do
        expect(creator).to have_received(:call).with(instance_of(Reservation),
                                                     hash_including(context: :admin)).twice
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
