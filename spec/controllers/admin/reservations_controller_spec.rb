require 'rails_helper'

module Admin
  RSpec.describe ReservationsController do
    include Sorcery::TestHelpers::Rails::Controller
    let(:user) { create :user }
    before { login_user user }

    let(:seller1) { create :seller, first_name: 'AAAAA', last_name: 'BBBB', email: 'zzz@bbb.de' }
    let(:seller2) { create :seller, first_name: 'ZZZZZ', last_name: 'EEEE', email: 'bbb@bbb.de' }
    let(:seller3) { create :seller, first_name: 'BBBBB', last_name: 'BBBB', email: 'aaa@bbb.de' }
    let(:sellers) { [seller1, seller2, seller3] }
    let(:event) { create :event_with_ongoing_reservation }
    let!(:reservations) { sellers.map { |seller| create :reservation, event: event, seller: seller } }

    describe 'GET index' do
      let(:index_params) { { event_id: event.id }.merge params }
      let(:params) { {} }
      before { get :index, index_params }

      its(:searchable?) { is_expected.to eq true }

      describe '@sellers' do
        subject { assigns :reservations }
        its(:first) { is_expected.to eq reservations[0] }

        context 'when search parameter is given' do
          let(:params) { { search: 'bbbb' } }
          its(:count) { is_expected.to eq 2 }
        end

        context 'when sort parameter is set to email' do
          let(:params) { { sort: 'sellers.email' } }
          its(:first) { is_expected.to eq reservations[2] }
        end

        context 'when sort parameter is set to name' do
          let(:params) { { sort: 'sellers.name' } }
          its(:first) { is_expected.to eq reservations[0] }
        end

        context 'when direction parameter is set to desc' do
          context 'when sort parameter is set to email' do
            let(:params) { { sort: 'sellers.email', dir: 'desc' } }
            its(:first) { is_expected.to eq reservations[0] }
          end

          context 'when sort parameter is set to name' do
            let(:params) { { sort: 'sellers.name', dir: 'desc' } }
            its(:first) { is_expected.to eq reservations[1] }
          end
        end
      end
    end

    describe 'POST create' do
      let(:action) { post :create, event_id: event.id, reservation: { seller_id: [seller1.id, seller2.id] } }
      let(:reservation) { create :reservation }

      before do
        creator = double
        expect(creator).to receive(:create).with(instance_of(Event), instance_of(Seller),
                                                 hash_including(context: :admin),
                                                 hash_including(host: 'test.host')).twice.and_return reservation
        expect(Reservations::CreateReservation).to receive(:new).and_return creator
        action
      end

      it { is_expected.to redirect_to admin_event_reservations_path }
      it 'notifies about the reservations' do
        expect(flash[:notice]).to be_present
      end

      context 'when reservations were not persisted' do
        let(:reservation) { build :reservation }
        it { is_expected.to redirect_to admin_event_reservations_path }
        it 'notifies about the reservations count' do
          expect(flash[:notice]).to be_present
        end
      end
    end
  end
end
