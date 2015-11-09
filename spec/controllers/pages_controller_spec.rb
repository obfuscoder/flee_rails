require 'rails_helper'

RSpec.describe PagesController do
  describe 'GET home' do
    let(:preparations) {}
    before do
      preparations
      get :home
    end

    context 'with events' do
      let(:event) { create(:event) }
      let(:preparations) { event }

      it 'assigns all events as @events' do
        expect(assigns(:events)).to match_array([event])
      end
    end
    context 'without events' do
      it 'assigns an empty array as @events' do
        expect(assigns(:events)).to match_array([])
      end
    end
  end

  %w(home contact imprint privacy).each do |page_name|
    describe "GET #{page_name}" do
      before { get page_name.to_sym }

      it { expect(response).to have_http_status(:success) }
      it { expect(response).to render_template(page_name) }
    end
  end
end
