require 'rails_helper'

module Api
  RSpec.describe EventsController do
    describe 'GET show' do
      let!(:event) { FactoryGirl.create :event }
      let!(:categories) { FactoryGirl.create_list :category, 5 }
      before { get :show, format: :json, id: event.id }
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
  end
end
