require 'rails_helper'

module Api
  RSpec.describe EventsController do
    describe 'GET show' do
      let!(:event) { FactoryGirl.create :event }
      let!(:categories) { FactoryGirl.create_list :category, 5 }
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
  end
end
