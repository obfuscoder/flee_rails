# frozen_string_literal: true

require 'rails_helper'

module Admin
  RSpec.describe ItemsController do
    include Sorcery::TestHelpers::Rails::Controller
    let(:user) { create :user }
    let!(:reservation) { create :reservation }
    let!(:item) { create :item_with_code, reservation: reservation }

    before { login_user user }

    describe 'DELETE delete_code' do
      before { delete :delete_code, params: { reservation_id: reservation.id, id: item.id } }

      it { is_expected.to redirect_to admin_reservation_items_path(reservation) }

      it 'frees item number and code' do
        expect(item.reload.code).to be_nil
        expect(item.reload.number).to be_nil
      end
    end

    describe 'DELETE delete_all_codes' do
      let!(:another_item) { create :item_with_code, reservation: reservation }

      before { delete :delete_all_codes, params: { reservation_id: reservation.id } }

      it { is_expected.to redirect_to admin_reservation_items_path(reservation) }

      it 'frees all item numbers and codes' do
        expect(item.reload.code).to be_nil
        expect(item.reload.number).to be_nil
        expect(another_item.reload.code).to be_nil
        expect(another_item.reload.number).to be_nil
      end
    end

    describe 'GET new' do
      before { preparations }

      before { get :new, params: { reservation_id: reservation.id } }

      let(:preparations) {}

      describe 'response' do
        subject { response }

        it { is_expected.to render_template :new }
        it { is_expected.to have_http_status :ok }
      end

      describe '@item' do
        subject { assigns :item }

        it { is_expected.to be_a_new Item }

        [false, true].each do |donation_default|
          context "when donation default setting is #{donation_default}" do
            let(:preparations) { Client.first.update donation_of_unsold_items_default: donation_default }

            its(:donation) { is_expected.to eq donation_default }
          end
        end
      end
    end

    describe 'POST create' do
      let(:category) { create :category }
      let(:new_item) { build :item, reservation: reservation, category: category }
      let(:preparations) {}

      before do
        preparations
        post :create, params: { reservation_id: reservation.id, item: new_item.attributes }
      end

      it { is_expected.to redirect_to admin_reservation_items_path(reservation) }

      it 'creates new item' do
        expect(Item.last.description).to eq new_item.description
      end

      context 'when donation is enabled' do
        let(:preparations) { reservation.event.update donation_of_unsold_items_enabled: true }

        [true, false].each do |donation|
          context "when category donation_enforces is #{donation}" do
            let(:donation_enforced) { donation }
            let(:category) { create :category, donation_enforced: donation_enforced }
            let(:new_item) { build :item, reservation: reservation, category: category }

            it "creates new item with donation set to #{donation}" do
              expect(Item.last.donation?).to eq donation_enforced
            end
          end
        end
      end
    end

    describe 'GET edit' do
      before { get :edit, params: { reservation_id: reservation.id, id: item.id } }

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
      before { put :update, params: { reservation_id: reservation.id, id: item.id, item: item.attributes } }

      it { is_expected.to redirect_to admin_reservation_items_path(reservation) }

      context 'when donation is enabled' do
        let!(:reservation) { create :reservation, event: event }
        let(:event) { create :event_with_ongoing_reservation, donation_of_unsold_items_enabled: true }

        context 'when category donation is enforced' do
          let(:category) { create :category_with_enforced_donation }
          let!(:item) { create :item_with_code, reservation: reservation, category: category }

          it 'sets item donation' do
            expect(item.reload.donation).to eq true
          end
        end
      end
    end

    describe 'GET labels' do
      before { get :labels, params: { reservation_id: reservation.id } }

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
      before { post :create_labels, params: { reservation_id: reservation.id, labels: { item: [item.id] } } }

      describe 'response' do
        subject { response }

        its(:content_type) { is_expected.to eq 'application/pdf' }
        it { is_expected.to have_http_status :ok }
      end
    end
  end
end
