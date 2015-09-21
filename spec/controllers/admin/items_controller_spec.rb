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

    describe 'GET new' do
      before { get :new, reservation_id: reservation.id }

      describe 'response' do
        subject { response }
        it { is_expected.to render_template :new }
        it { is_expected.to have_http_status :ok }
      end

      describe '@item' do
        subject { assigns :item }
        it { is_expected.to be_a_new Item }
      end
    end

    describe 'POST create' do
      let(:new_item) { FactoryGirl.build(:item, reservation: reservation) }
      before { post :create, reservation_id: reservation.id, item: new_item.attributes }

      it { is_expected.to redirect_to admin_reservation_items_path(reservation) }

      it 'creates new item' do
        expect(Item.last.description).to eq new_item.description
      end
    end

    describe 'GET edit' do
      before { get :edit, reservation_id: reservation.id, id: item.id }

      describe 'response' do
        subject { response }
        it { is_expected.to render_template :edit }
        it { is_expected.to have_http_status :ok }
      end

      describe '@item' do
        subject { assigns :item }
        it { is_expected.to eq item }
      end
    end

    describe 'PUT update' do
      before { put :update, reservation_id: reservation.id, id: item.id, item: item.attributes }

      it { is_expected.to redirect_to admin_reservation_items_path(reservation) }
    end

    describe 'GET labels' do
      before { get :labels, reservation_id: reservation.id }

      describe 'response' do
        subject { response }
        it { is_expected.to render_template :labels }
        it { is_expected.to have_http_status :ok }
      end

      describe '@items' do
        subject { assigns :items }
        it { is_expected.to eq reservation.items }
      end
    end

    describe 'POST create_labels' do
      before { post :create_labels, reservation_id: reservation.id, labels: { item: [item.id] } }

      describe 'response' do
        subject { response }
        its(:content_type) { is_expected.to eq 'application/pdf' }
        it { is_expected.to have_http_status :ok }
      end
    end
  end
end
