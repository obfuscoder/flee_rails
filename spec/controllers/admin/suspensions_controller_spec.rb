# frozen_string_literal: true

require 'rails_helper'

module Admin
  RSpec.describe SuspensionsController do
    include Sorcery::TestHelpers::Rails::Controller
    let(:user) { create :user }
    let(:event) { create :event }

    before do
      login_user user
      allow(SuspensionsQuery).to receive(:new).with(event).and_return query
    end

    describe 'GET index' do
      before { get :index, index_params }

      let(:index_params) { { event_id: event.id }.merge params }
      let(:params) { {} }
      let(:suspensions) { double }
      let(:query) { double search: suspensions }

      context 'with search parameters' do
        let(:params) { { search: 'needle', sort: 'reason', dir: 'desc', page: '2' } }

        it 'uses search params when querying' do
          expect(query).to have_received(:search).with('needle', '2', 'reason' => 'desc')
        end
      end

      describe 'response' do
        subject { response }

        it { is_expected.to have_http_status(:ok) }
        it { is_expected.to render_template(:index) }
      end

      describe '@suspensions' do
        subject { assigns :suspensions }

        it { is_expected.to eq suspensions }
      end
    end

    describe 'GET new' do
      before { get :new, event_id: event.id }

      let(:query) { double suspensible_sellers: suspensible_sellers }
      let(:suspensible_sellers) { double order: sellers }
      let(:sellers) { double }

      describe 'response' do
        subject { response }

        it { is_expected.to have_http_status(:ok) }
        it { is_expected.to render_template(:new) }
      end

      describe '@sellers' do
        subject { assigns :sellers }

        it { is_expected.to eq sellers }
      end
    end

    describe 'POST create' do
      before { post :create, event_id: event.id, suspension: { seller_id: seller_ids, reason: reason } }

      let(:query) { double create: suspensions }
      let(:seller_ids) { %w[1 2] }
      let(:suspensions) { double count: seller_ids.count }
      let(:reason) { 'reason' }

      it 'uses SuspensionsQuery to create suspensions' do
        expect(query).to have_received(:create).with(seller_ids, reason)
      end

      describe 'response' do
        subject { response }

        it { is_expected.to redirect_to admin_event_suspensions_path }
      end
    end

    describe 'GET edit' do
      before { get :edit, event_id: event.id, id: id }

      let(:id) { '5' }
      let(:query) { double find: suspension }
      let(:suspension) { double }

      it 'uses SuspensionsQuery to find suspension' do
        expect(query).to have_received(:find).with(id)
      end

      describe 'response' do
        subject { response }

        it { is_expected.to have_http_status :ok }
        it { is_expected.to render_template :edit }
      end

      describe '@suspension' do
        subject { assigns :suspension }

        it { is_expected.to eq suspension }
      end
    end

    describe 'PUT update' do
      let(:suspension) { double update: true }
      let(:query) { double find: suspension }
      let(:id) { '5' }
      let(:reason) { 'reason' }

      before { put :update, event_id: event.id, id: id, suspension: { reason: reason } }

      it 'uses SuspensionsQuery to find suspension' do
        expect(query).to have_received(:find).with(id)
      end

      it 'updates suspension' do
        expect(suspension).to have_received(:update).with(reason: reason)
      end

      describe 'response' do
        subject { response }

        it { is_expected.to redirect_to admin_event_suspensions_path }
      end

      context 'when update failed' do
        let(:suspension) { double update: false }

        describe 'response' do
          subject { response }

          it { is_expected.to have_http_status(:ok) }
          it { is_expected.to render_template(:edit) }
        end

        describe '@suspension' do
          subject { assigns :suspension }

          it { is_expected.to eq suspension }
        end
      end
    end

    describe 'DELETE destroy' do
      let(:suspension) { double destroy: nil }
      let(:query) { double find: suspension }
      let(:id) { '5' }

      before { delete :destroy, event_id: event.id, id: id }

      it 'uses SuspensionsQuery to find suspension' do
        expect(query).to have_received(:find).with(id)
      end

      it 'destroys suspension' do
        expect(suspension).to have_received(:destroy)
      end

      describe 'response' do
        subject { response }

        it { is_expected.to redirect_to admin_event_suspensions_path }
      end
    end
  end
end
