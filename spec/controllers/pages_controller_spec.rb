require 'rails_helper'

RSpec.describe PagesController do
  describe 'GET home' do
    let(:preparations) {}

    before do
      preparations
      request.host = request_host
      get :home
    end

    context 'when request host is for demo' do
      let(:request_host) { 'demo.test.host' }

      context 'with events' do
        let(:event) { create :event }
        let(:event_of_other_client) { create :event, client: create(:client) }
        let(:preparations) { event }

        describe '@events' do
          subject { assigns :events }

          it { is_expected.to include event }
          it { is_expected.to have(1).item }
          it { is_expected.not_to include event_of_other_client }
        end
      end

      context 'without events' do
        it 'assigns an empty array as @events' do
          expect(assigns(:events)).to match_array([])
        end
      end
    end

    context 'when request host is for main page' do
      let(:request_host) { 'test.host' }

      describe 'response' do
        subject { response }

        it { is_expected.to redirect_to :pages_index }
      end
    end
  end

  %w[home imprint privacy].each do |page_name|
    describe "GET #{page_name}" do
      before do
        request.host = 'demo.test.host'
        get page_name.to_sym
      end

      describe 'response' do
        subject { response }

        it { is_expected.to have_http_status :success }
        it { is_expected.to render_template page_name }
      end
    end
  end

  describe 'GET index' do
    let(:demo_client) { Client.find_by key: 'demo' }
    let!(:client) { create :client }
    let!(:event) { create :event, client: client }
    let!(:demo_event) { create :event }

    before { get :index }

    describe 'response' do
      subject { response }

      it { is_expected.to have_http_status :success }
      it { is_expected.to render_template :index }
    end

    describe '@clients' do
      subject { assigns :clients }

      it { is_expected.to include client }
      it { is_expected.not_to include demo_client }
    end

    describe '@events' do
      subject { assigns :events }

      it { is_expected.to include event }
      it { is_expected.not_to include demo_event }
    end
  end
end
