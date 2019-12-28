require 'rails_helper'

describe ReservationsController do
  let(:event) { create :event_with_ongoing_reservation }
  let(:seller) { build :seller }

  before { allow(controller).to receive(:current_seller).and_return seller }

  describe 'GET create' do
    let(:action) { get :create, params: { event_id: event.id } }
    let(:reservation) { create :reservation }
    let(:creator) { double call: reservation }
    let(:options) { { host: 'demo.test.host', from: from } }

    before do
      allow(CreateReservationOrder).to receive(:new).and_return creator
      action
    end

    it 'calls creator with reservation' do
      expect(creator).to have_received(:call).with(instance_of(Reservation))
    end

    it { is_expected.to redirect_to seller_path }

    it 'notifies about the created reservation order' do
      expect(flash[:notice]).to be_present
    end

    context 'when returned reservation had errors' do
      let(:error_message) { 'some error' }
      let(:reservation) { double errors: double(any?: true, full_messages: [error_message]) }

      it { is_expected.to redirect_to seller_path }

      it 'alerts about the failed reservation' do
        expect(flash[:alert]).to be_present
        expect(flash[:alert]).to include error_message
      end
    end
  end

  describe 'GET import' do
    subject(:action) { get :import, params: { event_id: event.id, id: reservation.id } }

    let(:reservation) { create :reservation, event: event, seller: seller }

    describe 'response' do
      subject { response }

      before { action }

      it { is_expected.to have_http_status :ok }
      it { is_expected.to render_template :import }
    end

    describe '@reservations' do
      subject(:reservations) { assigns :reservations }

      before { action }

      let!(:previous_reservation) do
        Timecop.freeze 1.year.ago do
          create :reservation, seller: seller
        end
      end

      it { is_expected.to have(1).element }
      it { is_expected.to include previous_reservation }
    end
  end

  describe 'POST import' do
    subject(:action) do
      post :import, params: {
        event_id: event.id,
        id: reservation.id,
        import: {
          from_reservation: previous_reservation.id, item: items
        }
      }
    end

    let(:reservation) { create :reservation, event: event, seller: seller }
    let(:previous_reservation) { create :reservation, seller: seller }
    let(:items) { create_list :item, 5, reservation: previous_reservation }

    describe 'response' do
      subject { response }

      before { action }

      it { is_expected.to redirect_to event_reservation_items_path(event, reservation) }
    end

    def meh(reservation)
      reservation.reload.items.count
    end

    it 'copies items content to current reservation' do
      expect { action }.to change { meh(reservation) }.by(5)
    end
  end

  describe 'GET import_from' do
    subject(:action) do
      get :import_from, params: { event_id: event.id, reservation_id: reservation.id, id: previous_reservation.id }
    end

    let(:reservation) { create :reservation, event: event, seller: seller }
    let(:previous_reservation) { create :reservation, seller: seller }
    let!(:items) { create_list :item, 5, reservation: previous_reservation }
    let!(:sold_items) { create_list :sold_item, 3, reservation: previous_reservation }

    describe 'response' do
      subject { response }

      before { action }

      it { is_expected.to have_http_status :ok }
      it { is_expected.to render_template :import_from }
    end

    describe '@items' do
      subject { assigns :items }

      before { action }

      it { is_expected.to have(items.count).element }
    end

    describe '@event' do
      subject { assigns :event }

      before { action }

      it { is_expected.to eq event }
    end

    describe '@reservation' do
      subject { assigns :reservation }

      before { action }

      it { is_expected.to eq reservation }
    end

    describe '@from_reservation' do
      subject { assigns :from_reservation }

      before { action }

      it { is_expected.to eq previous_reservation }
    end
  end
end
