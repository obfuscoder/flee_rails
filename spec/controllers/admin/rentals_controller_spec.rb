# frozen_string_literal: true

require 'rails_helper'

module Admin
  RSpec.describe RentalsController do
    include Sorcery::TestHelpers::Rails::Controller
    let(:user) { create :user }
    let(:event) { create :event }

    before do
      login_user user
      allow(RentalsQuery).to receive(:new).with(event).and_return query
    end

    describe 'GET index' do
      before { get :index, event_id: event.id }

      let(:query) { double all: rentals }
      let(:rentals) { double }

      describe 'response' do
        subject { response }

        it { is_expected.to have_http_status(:ok) }
        it { is_expected.to render_template(:index) }
      end

      describe '@rentals' do
        subject { assigns :rentals }

        it { is_expected.to eq rentals }
      end
    end

    describe 'GET new' do
      before { get :new, event_id: event.id }

      let(:query) { double rentable_hardware: hardware, new: rental }
      let(:hardware) { double }
      let(:rental) { double }

      describe 'response' do
        subject { response }

        it { is_expected.to have_http_status(:ok) }
        it { is_expected.to render_template(:new) }
      end

      describe '@hardware' do
        subject { assigns :hardware }

        it { is_expected.to eq hardware }
      end

      describe '@rental' do
        subject { assigns :rental }

        it { is_expected.to eq rental }
      end
    end

    describe 'POST create' do
      before { post :create, event_id: event.id, rental: params }

      let(:query) { double rentable_hardware: hardware, create: rental }
      let(:params) { { hardware_id: '3', amount: '5' } }
      let(:rental) { double valid?: valid }
      let(:hardware) { double }
      let(:valid) { true }

      it 'uses RentalsQuery to create rental' do
        expect(query).to have_received(:create).with params
      end

      describe 'response' do
        subject { response }

        it { is_expected.to redirect_to admin_event_rentals_path }

        context 'when creation fails' do
          let(:valid) { false }

          it { is_expected.to render_template :new }
        end
      end
    end

    describe 'GET edit' do
      before { get :edit, event_id: event.id, id: id }

      let(:id) { '5' }
      let(:query) { double find: rental }
      let(:rental) { double }

      it 'uses RentalsQuery to find rental' do
        expect(query).to have_received(:find).with id
      end

      describe 'response' do
        subject { response }

        it { is_expected.to have_http_status :ok }
        it { is_expected.to render_template :edit }
      end

      describe '@rental' do
        subject { assigns :rental }

        it { is_expected.to eq rental }
      end
    end

    describe 'PUT update' do
      let(:rental) { double valid?: valid }
      let(:valid) { true }
      let(:query) { double update: rental }
      let(:id) { '5' }
      let(:amount) { '10' }

      before { put :update, event_id: event.id, id: id, rental: { amount: amount, ignored_param: true } }

      it 'uses RentalsQuery to update rental' do
        expect(query).to have_received(:update).with(id, amount: amount)
      end

      describe 'response' do
        subject { response }

        it { is_expected.to redirect_to admin_event_rentals_path }
      end

      context 'when update failed' do
        let(:valid) { false }

        describe 'response' do
          subject { response }

          it { is_expected.to have_http_status :ok }
          it { is_expected.to render_template :edit }
        end

        describe '@rental' do
          subject { assigns :rental }

          it { is_expected.to eq rental }
        end
      end
    end

    describe 'DELETE destroy' do
      let(:rental) { double destroy: nil }
      let(:query) { double find: rental }
      let(:id) { '5' }

      before { delete :destroy, event_id: event.id, id: id }

      it 'uses RentalsQuery to find rental' do
        expect(query).to have_received(:find).with id
      end

      it 'destroys rental' do
        expect(rental).to have_received(:destroy)
      end

      describe 'response' do
        subject { response }

        it { is_expected.to redirect_to admin_event_rentals_path }
      end
    end
  end
end
