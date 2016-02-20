require 'rails_helper'

RSpec.describe Reservation do
  subject { build(:reservation) }

  it { is_expected.to be_valid }
  it { is_expected.to validate_presence_of(:seller) }
  it { is_expected.to validate_presence_of(:event) }
  it { is_expected.to validate_numericality_of(:number).is_greater_than(0) }
  it { is_expected.to validate_uniqueness_of(:number).scoped_to(:event_id) }
  it { is_expected.to have_many(:items).dependent(:destroy) }
  it { is_expected.to belong_to(:event) }
  it { is_expected.to belong_to(:seller) }
  its(:to_s) { is_expected.to eq("#{subject.event.name} - #{subject.number}") }

  describe '#recent' do
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

    subject { Reservation.recent }

    it 'returns reservations for events not older than 4 weeks' do
      expect(subject).to include ongoing_reservation
      expect(subject).to include recent_reservation
      expect(subject).not_to include old_reservation
    end

    it 'orders events based on shopping_periods in descending order' do
      expect(subject.first).to eq ongoing_reservation
      expect(subject.last).to eq recent_reservation
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
end
