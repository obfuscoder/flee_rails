require 'rails_helper'

module Api
  RSpec.describe EventsController do
    describe 'GET show' do
      let!(:event) { create :event }
      let!(:categories) { create_list :category, 5 }
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
      let!(:event) { create :event_with_ongoing_reservation }
      let!(:reservation) { create :reservation, event: event }
      let!(:items) { create_list :item_with_code, 10, reservation: reservation }
      let(:transactions) do
        [
          {
            id: 'b1b3f5ea-0ed7-4f06-85d9-4837a56dc058',
            items: items.take(5).map(&:code),
            type: 'PURCHASE',
            date: '2015-08-27T10:57:29.094+02'
          },
          {
            id: 'f4bddeeb-e8a7-4f44-bf94-b974ebfd60d3',
            items: items.drop(5).take(5).map(&:code),
            type: 'PURCHASE',
            date: '2015-08-27T10:57:29.102+02'
          },
          {
            id: 'd308a289-fc58-4f0d-82ba-95dc8b42eaa6',
            items: items.drop(1).take(2).map(&:code),
            type: 'REFUND',
            date: '2015-08-27T10:57:29.105+02'
          }
        ]
      end

      before do
        @request.env['HTTP_AUTHORIZATION'] =
          ActionController::HttpAuthentication::Token.encode_credentials event.token
        post :transactions, _json: transactions, format: :json
      end

      describe 'response' do
        subject { response }
        it { is_expected.to have_http_status :ok }
        it 'sets sold date on sold items' do
          items.drop(5).take(5).each { |item| expect(item.reload.sold).not_to be_nil }
          expect(items.first.reload).not_to be_nil
          items.drop(3).take(2).each { |item| expect(item.reload.sold).not_to be_nil }
          items.drop(1).take(2).each { |item| expect(item.reload.sold).to be_nil }
        end
      end
    end
  end
end
