# frozen_string_literal: true

require 'rails_helper'

module Admin
  RSpec.describe AdminController do
    include Sorcery::TestHelpers::Rails::Controller
    let(:user) { create :user }
    before { login_user user }

    controller do
      def test
        render text: 'test'
      end
    end

    before do
      @routes.draw do
        get '/test', controller: 'admin/admin', action: :test
      end
    end

    before do
      preparations
      get :test
    end
    let(:preparations) {}

    describe '@menu' do
      subject(:menu) { assigns :menu }
      it 'contains link to admin home page' do
        expect(menu.find { |e| e[:link] == admin_path }).not_to be_empty
      end
    end
  end
end
