# frozen_string_literal: true

require 'rails_helper'

module Api
  RSpec.describe EventsController do
    describe 'GET show' do
      let!(:event) { create :event }
      let(:creator) { double call: data }
      let(:data) { 'data' }

      before do
        prerequisites
        allow(CreateEventData).to receive(:new).and_return creator
        get :show, format: :json
      end

      context 'with authorization header' do
        let(:prerequisites) do
          @request.env['HTTP_AUTHORIZATION'] =
            ActionController::HttpAuthentication::Token.encode_credentials token
        end

        context 'with invalid access token' do
          let(:token) { 'invalid' }

          describe 'response' do
            subject { response }

            it { is_expected.to have_http_status :unauthorized }
          end
        end

        context 'with valid access token' do
          let(:token) { event.token }

          describe 'response' do
            subject { response }

            it { is_expected.to have_http_status :ok }
            its(:content_type) { is_expected.to eq 'application/octet-stream' }
            its(:body) { is_expected.to eq data }
          end

          it 'calls CreateEventData' do
            expect(CreateEventData).to have_received(:new).with(Client.first)
            expect(creator).to have_received(:call).with(event)
          end
        end
      end

      context 'without access token' do
        let(:prerequisites) {}

        describe 'response' do
          subject { response }

          it { is_expected.to have_http_status :unauthorized }
        end
      end
    end

    describe 'POST transactions' do
      let(:event) { create :event }
      let(:transactions) { [{ id: 'id', date: 'date', type: 'type', items: %w[item1 item2] }] }
      let(:importer) { double :importer, call: count }
      let(:count) { 10 }

      let(:token) { event.token }
      let(:prerequisites) do
        @request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Token.encode_credentials token
      end

      before do
        prerequisites
        allow(ImportTransactions).to receive(:new).with(event).and_return importer
        post :transactions, params: { _json: transactions }, format: :json
      end

      describe 'response' do
        subject { response }

        it { is_expected.to have_http_status :no_content }

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
          let(:event) { create :event, client: other_client }

          it { is_expected.to have_http_status :no_content }

          it 'calls ImportTransactions with proper params' do
            expect(importer).to have_received(:call).with transactions
          end
        end
      end

      it 'calls ImportTransactions with proper params' do
        expect(importer).to have_received(:call).with transactions
      end
    end
  end
end
