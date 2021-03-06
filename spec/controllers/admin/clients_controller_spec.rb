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
    subject(:action) { put :update, params: { client: client_params } }

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
        import_items_allowed: '1',
        import_item_code_enabled: '1',
        precise_bill_amounts: '1',
        logo: 'https://example.org/logo.png',
        gates: true
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
                                                    import_items_allowed: true,
                                                    import_item_code_enabled: true,
                                                    precise_bill_amounts: true,
                                                    price_precision: 1.0,
                                                    reservation_fee: 10.0,
                                                    commission_rate: 0.5,
                                                    logo: 'https://example.org/logo.png',
                                                    gates: true
    end
  end
end
