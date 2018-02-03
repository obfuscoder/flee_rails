# frozen_string_literal: true

require 'rails_helper'

module Api
  RSpec.describe EventsController do
    describe 'GET show' do
      let!(:event) { create :event }
      let!(:categories) { create_list :category, 5 }
      let!(:stock_items) { create_list :stock_item, 4 }
      before do
        prerequisites
        get :show, format: :json
      end

      context 'with valid access token' do
        let(:prerequisites) do
          @request.env['HTTP_AUTHORIZATION'] =
            ActionController::HttpAuthentication::Token.encode_credentials event.token
        end
        describe 'response' do
          subject { response }
          it { is_expected.to have_http_status :ok }
          its(:content_type) { is_expected.to eq 'application/json' }
        end

        describe '@event' do
          subject { assigns :event }
          it { is_expected.to eq event }
        end

        describe '@categories' do
          subject { assigns :categories }
          it { is_expected.to eq categories }
        end

        describe '@stock_items' do
          subject { assigns :stock_items }
          it { is_expected.to eq stock_items }
        end
      end

      context 'with invalid access token' do
        let(:prerequisites) {}
        describe 'response' do
          subject { response }
          it { is_expected.to have_http_status :unauthorized }
        end
      end
    end

    describe 'POST transactions' do
      let(:event) { create :event }
      let(:transactions) { { key: :value } }

      before do
        prerequisites
        allow(HandleTransactions).to receive(:new).with(event).and_return handle_transactions
        post :transactions, _json: transactions, format: :json
      end

      let(:handle_transactions) { double call: nil }
      let(:token) { event.token }
      let(:prerequisites) do
        @request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Token.encode_credentials token
      end

      describe 'response' do
        subject { response }
        it { is_expected.to have_http_status :ok }

        describe 'when not using authorization header' do
          let(:prerequisites) {}
          it { is_expected.to have_http_status :unauthorized }
        end

        describe 'when using unknown authorization header' do
          let(:token) { 'unknown' }
          it { is_expected.to have_http_status :unauthorized }
        end

        describe 'when using event token from different client' do
          let(:other_client) { create :client }
          let(:other_event) { create :event, client: other_client }
          let(:token) { other_event.token }
          it { is_expected.to have_http_status :unauthorized }
        end
      end

      it 'calls HandleTransactions with proper params' do
        expect(handle_transactions).to have_received(:call).with(transactions)
      end
    end
  end
end
