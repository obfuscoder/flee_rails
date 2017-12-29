# frozen_string_literal: true

require 'rails_helper'

module Admin
  RSpec.describe SessionsController do
    let(:user) { create :user }
    describe 'POST :create (login)' do
      before { post :create, user: { email: user.email, password: 'password' } }
      describe 'response' do
        subject { response }
        it { is_expected.to redirect_to admin_path }
      end

      context 'when user belongs to different client' do
        let(:user) { create :user, client: create(:client) }
        describe 'response' do
          subject { response }
          it { is_expected.to have_http_status :ok }
          it { is_expected.to render_template :new }
        end
      end
    end
  end
end
