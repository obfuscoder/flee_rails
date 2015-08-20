require 'rails_helper'

RSpec.describe ItemsController do
  let(:seller) { FactoryGirl.create :seller }
  let(:reservation) { FactoryGirl.create :reservation, seller: seller }
  let(:event) { reservation.event }
  let(:item) { FactoryGirl.create :item, reservation: reservation }
  let(:item_with_code) { FactoryGirl.create :item_with_code, reservation: reservation }
  let(:other_item) { FactoryGirl.create :item }

  before { session[:seller_id] = seller.id }

  shared_examples 'obey item code' do
    context 'when item has code' do
      let(:item) { item_with_code }
      it 'does not allow action' do
        expect(action).to redirect_to event_items_path(event)
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
        expect(action).to have_http_status :unauthorized
      end
    end
  end

  describe 'GET new' do
    before do
      preparations
      get :new, event_id: event.id
    end

    describe '@item' do
      subject { assigns :item }

      [false, true].each do |donation_default|
        context "when donation default setting is #{donation_default}" do
          let(:preparations) do
            allow(Settings.brands.default).to receive(:donation_of_unsold_items_default).and_return(donation_default)
          end
          its(:donation) { is_expected.to eq donation_default }
        end
      end
    end
  end

  describe 'GET index' do
    let!(:items) { FactoryGirl.create_list :item, 25, reservation: reservation }
    let(:options) { {} }
    let(:action) { get :index, options.merge(event_id: event.id) }
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
    let(:action) { get :edit, event_id: event.id, id: item.id }
    it_behaves_like 'obey item code'
    it_behaves_like 'obey ownership'
  end

  describe 'PUT update' do
    let(:action) { put :update, event_id: event.id, id: item.id, item: { description: item.description } }
    it_behaves_like 'obey item code'
    it_behaves_like 'obey ownership'
  end

  describe 'DELETE destroy' do
    let(:action) { delete :destroy, event_id: event.id, id: item.id }
    it_behaves_like 'obey item code'
    it_behaves_like 'obey ownership'
  end
end
