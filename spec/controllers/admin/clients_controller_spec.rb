# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Admin::ClientsController do
  include Sorcery::TestHelpers::Rails::Controller
  let(:user) { create :user }

  before { login_user user }

  describe 'GET edit' do
    subject(:action) { get :edit }

    it { is_expected.to have_http_status :ok }
    it { is_expected.to render_template :edit }

    describe '@client' do
      subject { assigns :client }

      before { action }

      it { is_expected.to eq user.client }
    end
  end

  describe 'PUT update' do
    subject(:action) { put :update, client: client_params }

    let(:client_params) do
      {
        name: 'name',
        short_name: 'short_name',
        address: 'address',
        invoice_address: 'invoice_address',
        intro: 'intro',
        outro: 'outro',
        terms: 'terms',
        price_precision: '1',
        reservation_fee: '10',
        commission_rate: '0.5',
        donation_of_unsold_items: '1',
        donation_of_unsold_items_default: '1',
        reservation_by_seller_forbidden: '1',
        reservation_numbers_assignable: '1',
        auto_reservation_numbers_start: '100',
        import_items_allowed: '1'
      }
    end

    it { is_expected.to redirect_to admin_path }

    it 'updates current client' do
      action
      expect(user.client.reload).to have_attributes name: client_params[:name],
                                                    short_name: client_params[:short_name],
                                                    donation_of_unsold_items: true,
                                                    donation_of_unsold_items_default: true,
                                                    reservation_by_seller_forbidden: true,
                                                    reservation_numbers_assignable: true,
                                                    auto_reservation_numbers_start: 100,
                                                    import_items_allowed: true
    end
  end
end
