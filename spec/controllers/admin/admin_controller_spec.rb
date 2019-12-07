# frozen_string_literal: true

require 'rails_helper'

module Admin
  RSpec.describe AdminController do
    include Sorcery::TestHelpers::Rails::Controller
    let(:user) { create :user }
    let(:preparations) {}

    controller do
      def test
        render plain: 'test'
      end
    end

    before do
      login_user user
      @routes.draw do
        get '/test', controller: 'admin/admin', action: :test
      end
      preparations
      get :test
    end

    describe '@menu' do
      subject(:menu) { assigns :menu }

      it 'contains link to admin home page' do
        expect(menu.find { |e| e[:link] == admin_path }).not_to be_empty
      end
    end
  end
end
