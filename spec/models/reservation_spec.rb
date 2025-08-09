require 'rails_helper'

RSpec.describe Reservation do
  subject(:reservation) { build :reservation }

  it { is_expected.to be_valid }
  it { is_expected.to belong_to(:event) }
  it { is_expected.to belong_to(:seller) }
  it { is_expected.to have_many(:items).dependent(:destroy) }

  it { is_expected.to validate_presence_of(:seller) }
  it { is_expected.to validate_presence_of(:event) }
  it { is_expected.to validate_numericality_of(:number).is_greater_than(0).is_less_than(1000) }
  it { is_expected.to validate_uniqueness_of(:number).scoped_to(:event_id) }

  its(:to_s) { is_expected.to eq("#{reservation.event.name} - #{reservation.number}") }

  context 'when seller was deleted' do
    subject(:reservation) { create :reservation }

    before do
      reservation.seller.destroy
      reservation.reload
    end

    its(:seller) { is_expected.not_to be_nil }
  end

  describe '#number' do
    subject(:reservation) { create :reservation, seller: seller, event: event }

    let(:seller) { create :seller }
    let(:event) { create :event_with_ongoing_reservation }

    its(:number) { is_expected.to eq 1 }

    context 'when Client#auto_reservation_numbers_start is 200' do
      before { Client.first.update! auto_reservation_numbers_start: 200 }

      its(:number) { is_expected.to eq 200 }

      context 'when Seller#default_reservation_number is 100' do
        let(:seller) { create :seller, default_reservation_number: 100 }

        its(:number) { is_expected.to eq 100 }

        context 'when there is already another reservation with number 100' do
          let!(:other_reservation) { create :reservation, event: event, number: 100 }

          its(:number) { is_expected.to eq 200 }
        end
      end
    end
  end

  context 'when seller is suspended for the event' do
    let(:event) { create :event_with_ongoing_reservation }
    let(:seller) { create :seller }
    let!(:suspension) { create :suspension, event: event, seller: seller }

    subject(:reservation) { build :reservation, event: event, seller: seller }

    it { is_expected.not_to be_valid }

    context 'when validated' do
      before { reservation.valid? }

      describe 'its error messages' do
        subject(:messages) { reservation.errors.messages }

        it { is_expected.to have_key :event }

        describe 'error message for event' do
          subject { messages[:event][0] }

          it { is_expected.not_to include 'translation missing' }
          it { is_expected.to include suspension.reason }
        end
      end
    end
  end

  context 'when reservation by seller is forbidden' do
    subject(:reservation) { build :reservation, seller: seller, event: event }

    let(:client) { create :client, reservation_by_seller_forbidden: true }
    let(:seller) { create :seller, client: client }
    let(:event) { create :event_with_ongoing_reservation, client: client }

    it { is_expected.not_to be_valid }

    context 'when validated' do
      before { reservation.valid? }

      describe 'its error messages' do
        subject(:messages) { reservation.errors.messages }

        describe 'error message for base' do
          subject { messages[:base].first }

          it { is_expected.not_to include 'translation missing' }
        end
      end
    end
  end

  describe '#recent' do
    subject(:action) { described_class.recent }

    let!(:old_reservation) do
      reservation = nil
      Timecop.travel 5.months.ago do
        reservation = create :reservation
      end
      reservation
    end
    let!(:recent_reservation) do
      reservation = nil
      Timecop.travel 2.months.ago do
        reservation = create :reservation
      end
      reservation
    end
    let!(:ongoing_reservation) { create :reservation }

    it 'returns reservations for events not older than 4 weeks' do
      expect(action).to include ongoing_reservation
      expect(action).to include recent_reservation
      expect(action).not_to include old_reservation
    end

    it 'orders events based on shopping_periods in descending order' do
      expect(action.first).to eq ongoing_reservation
      expect(action.last).to eq recent_reservation
    end
  end

  describe '#max_reservations_per_seller' do
    let(:event) { create :event_with_ongoing_reservation, max_reservations_per_seller: 2 }
    let(:seller) { create :seller }
    let!(:reservation) { create :reservation, event: event, seller: seller }

    context 'when limit is not yet reached' do
      it 'can create another reservation for the seller and event' do
        expect { create :reservation, event: event, seller: seller }.not_to raise_error
      end
    end

    context 'when limit has been reached' do
      let(:event) { create :event_with_ongoing_reservation, max_reservations_per_seller: 1 }

      it 'does not allow to create additional reservations for the event and seller' do
        expect { create :reservation, event: event, seller: seller }.to raise_error ActiveRecord::RecordInvalid
      end
    end
  end

  describe '#fee' do
    subject(:action) { reservation.fee }

    let(:event) { create :event_with_ongoing_reservation }
    let(:reservation) { create :reservation, event: event, fee: fee }
    let(:fee) { nil }

    it { is_expected.to eq reservation.event.reservation_fee }

    context 'when reservation fee is set' do
      let(:fee) { 1.5 }

      it { is_expected.to eq fee }
    end

    context 'when event reservation fee is based on item count' do
      let(:event) { create :event_with_ongoing_reservation, reservation_fee_based_on_item_count: true }

      it { is_expected.to eq 0 }

      context 'with items' do
        let(:items) { create_list :item, 5, reservation: reservation }

        before { items }

        it { is_expected.to eq 10 }

        context 'when reservation fee is set' do
          let(:fee) { 1.5 }

          it { is_expected.to eq 7.5 }
        end
      end
    end
  end

  describe '#commission_rate' do
    subject(:action) { reservation.commission_rate }

    let(:rate) { 0.9 }

    context 'when commission rate is set' do
      before { reservation.commission_rate = rate }

      it { is_expected.to eq rate }
    end

    context 'when commission rate is not set' do
      it { is_expected.to eq reservation.event.commission_rate }
    end
  end

  describe '#max_items' do
    subject(:action) { reservation.max_items }

    let(:max_items) { 42 }

    context 'when max items is set' do
      before { reservation.max_items = max_items }

      it { is_expected.to eq max_items }
    end

    context 'when max items is not set' do
      it { is_expected.to eq reservation.event.max_items_per_reservation }
    end
  end

  describe '#increase_label_counter' do
    subject(:action) { reservation.increase_label_counter }

    let(:reservation) { create :reservation }

    context 'when label counter is nil' do
      it 'increases label_counter' do
        expect { action }.to change(reservation, :label_counter).from(nil).to(1)
      end

      it 'returns label counter' do
        expect(action).to eq 1
      end
    end

    context 'when reservation limit is reached' do
      before { reservation.event.update max_reservations: 0, max_reservations_per_seller: 0 }

      it 'increases label_counter' do
        expect { action }.not_to raise_error
      end
    end

    context 'when label counter is 2' do
      before { reservation.update label_counter: 2 }

      it 'increases label_counter' do
        expect { action }.to change(reservation, :label_counter).to(3)
      end

      it 'returns label counter' do
        expect(action).to eq 3
      end
    end
  end

  describe '#previous?' do
    subject(:action) { reservation.previous? }

    let(:seller) { create :seller }
    let(:reservation) { create :reservation, seller: seller }

    it { is_expected.to eq false }

    context 'when previous reservations exist' do
      let!(:previous_reservation) do
        Timecop.freeze 1.year.ago do
          create :reservation, seller: seller
        end
      end

      it { is_expected.to eq true }
    end
  end

  describe '#previous' do
    subject(:action) { reservation.previous }

    let(:seller) { create :seller }
    let(:reservation) { create :reservation, seller: seller }

    it { is_expected.to be_empty }

    context 'when previous reservations exist' do
      let!(:previous_reservation) do
        Timecop.freeze 1.year.ago do
          create :reservation, seller: seller
        end
      end

      it { is_expected.to have(1).element }
      it { is_expected.to include previous_reservation }
    end
  end
end
