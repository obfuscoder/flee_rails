require 'rails_helper'

module Admin
  RSpec.describe ItemsController do
    include Sorcery::TestHelpers::Rails::Controller
    let(:user) { FactoryGirl.create :user }
    before { login_user user }

    let!(:reservation) { FactoryGirl.create :reservation }
    let!(:item) { FactoryGirl.create :item_with_code, reservation: reservation }

    describe 'DELETE delete_code' do
      before { delete :delete_code, reservation_id: reservation.id, id: item.id }
      it { is_expected.to redirect_to admin_reservation_items_path(reservation) }
      it 'frees item number and code' do
        expect(item.reload.code).to be_nil
        expect(item.reload.number).to be_nil
      end
    end

    describe 'DELETE delete_all_codes' do
      let!(:another_item) { FactoryGirl.create :item_with_code, reservation: reservation }
      before { delete :delete_all_codes, reservation_id: reservation.id }
      it { is_expected.to redirect_to admin_reservation_items_path(reservation) }
      it 'frees all item numbers and codes' do
        expect(item.reload.code).to be_nil
        expect(item.reload.number).to be_nil
        expect(another_item.reload.code).to be_nil
        expect(another_item.reload.number).to be_nil
      end
    end
  end
end
