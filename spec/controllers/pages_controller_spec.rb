require 'rails_helper'

RSpec.describe PagesController do

  describe "GET home" do
    before do
      get :home
    end

    it { expect(response).to have_http_status(:success) }
    it { expect(response).to render_template('home') }
  end

  describe "GET contact" do
    before do
      get :contact
    end

    it { expect(response).to have_http_status(:success) }
    it { expect(response).to render_template('contact') }
  end

  describe "GET imprint" do
    before do
      get :imprint
    end

    it { expect(response).to have_http_status(:success) }
    it { expect(response).to render_template('imprint') }
  end

  describe "GET privacy" do
    before do
      get :privacy
    end

    it { expect(response).to have_http_status(:success) }
    it { expect(response).to render_template('privacy') }
  end

end
