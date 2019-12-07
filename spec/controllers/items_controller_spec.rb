# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ItemsController do
  let(:seller) { create :seller }
  let(:event) { create :event_with_ongoing_reservation }
  let(:reservation) { create :reservation, seller: seller, event: event }
  let(:item) { create :item, reservation: reservation }
  let(:item_with_code) { create :item_with_code, reservation: reservation }
  let(:other_item) { create :item }

  before { session[:seller_id] = seller.id }

  shared_examples 'obey item code' do
    context 'when item has code' do
      let(:item) { item_with_code }

      it 'does not allow action' do
        expect(action).to redirect_to event_reservation_items_path(event, reservation)
      end

      it 'outputs alert' do
        action
        expect(flash[:alert]).to eq 'Für diesen Artikel wurde bereits ein Etikett erzeugt.'
      end
    end
  end

  shared_examples 'obey ownership' do
    context 'when another seller is signed in' do
      let(:item) { other_item }

      it 'forbids access' do
        expect { action }.to raise_error ActiveRecord::RecordNotFound
      end
    end
  end

  describe 'GET new' do
    before do
      preparations
      get :new, params: { event_id: event.id, reservation_id: reservation.id }
    end

    let(:preparations) {}

    describe '@item' do
      subject { assigns :item }

      [false, true].each do |donation_default|
        context "when donation default setting is #{donation_default}" do
          let(:preparations) { Client.first.update donation_of_unsold_items_default: donation_default }

          its(:donation) { is_expected.to eq donation_default }
        end
      end
    end

    describe '@categories' do
      subject(:categories) { assigns :categories }

      let(:preparations) do
        create :category, client: event.client
        create :category_with_enforced_donation, client: event.client
      end

      it { is_expected.to have(2).items }

      context 'when event donation is disabled' do
        it 'have donation enforced attributes' do
          categories.each do |category|
            expect(category).not_to include :data
          end
        end
      end

      context 'when event donation is enabled' do
        let(:event) { create :event_with_ongoing_reservation, donation_of_unsold_items_enabled: true }

        it 'have donation enforced attributes' do
          categories.each do |category|
            expect(category[2][:data]).to include :donation_enforced
          end
        end
      end

      %w[optional required disabled fixed].each do |option|
        context "with category having size option #{option}" do
          let(:size_option) { option }
          let(:preparations) { create :category, client: event.client, size_option: size_option }

          describe 'data element of that category' do
            subject(:data) { categories.first.last[:data] }

            it { is_expected.to include size_option: size_option }
          end
        end
      end

      context 'with category having size option fixed' do
        let(:category) do
          create(:category, client: event.client, size_option: :fixed).tap do |category|
            %w[XS S M L XL].each { |size| category.sizes.create value: size }
          end
        end
        let(:preparations) { category }

        describe 'data element of that category' do
          subject(:data) { categories.first.last[:data] }

          it { is_expected.to include sizes: 'XS|S|M|L|XL' }
        end
      end
    end
  end

  describe 'GET index' do
    let!(:items) { create_list :item, 25, reservation: reservation }
    let(:options) { {} }
    let(:action) { get :index, params: options.merge(event_id: event.id, reservation_id: reservation.id) }
    let(:preparations) {}

    before do
      preparations
      action
    end

    its(:searchable?) { is_expected.to eq true }

    describe '@items' do
      subject { assigns(:items) }

      it { is_expected.to eq items.take 10 }

      context 'when second page is requested' do
        let(:options) { { page: 2 } }

        it { is_expected.to eq items.drop(10).take(10) }

        it 'stores page in session' do
          expect(session['items_page']).to eq '2'
        end
      end

      context 'when second page is stored in session' do
        let(:preparations) { session['items_page'] = 2 }

        it { is_expected.to eq items.drop(10).take(10) }

        context 'when third page is requested' do
          let(:options) { { page: 3 } }

          it { is_expected.to eq items.drop 20 }
        end
      end
    end
  end

  describe 'GET edit' do
    let(:action) { get :edit, params: { event_id: event.id, reservation_id: reservation.id, id: item.id } }

    it_behaves_like 'obey item code'
    it_behaves_like 'obey ownership'
  end

  describe 'PUT update' do
    let(:action) do
      put :update, params: {
        event_id: event.id, reservation_id: reservation.id, id: item.id,
        item: { description: item.description, category_id: item.category.id }
      }
    end

    it_behaves_like 'obey item code'
    it_behaves_like 'obey ownership'
    context 'when donation is enabled' do
      before { event.update donation_of_unsold_items_enabled: true }

      context 'when category donation is enforced' do
        before { item.category.update donation_enforced: true }

        it 'sets item donation' do
          expect { action }.to change { item.reload.donation }.to true
        end
      end
    end
  end

  describe 'DELETE destroy' do
    let(:action) { delete :destroy, params: { event_id: event.id, reservation_id: reservation.id, id: item.id } }

    it_behaves_like 'obey item code'
    it_behaves_like 'obey ownership'
  end

  describe 'DELETE code' do
    let(:preparations) { item.create_code }
    let(:action) { delete :delete_code, params: { event_id: event.id, reservation_id: reservation.id, id: item.id } }

    it_behaves_like 'obey ownership'

    it 'deletes item code' do
      preparations
      expect(item.number).not_to be_nil
      expect(item.code).not_to be_nil
      action
      item.reload
      expect(item.number).to be_nil
      expect(item.code).to be_nil
    end
  end
end
