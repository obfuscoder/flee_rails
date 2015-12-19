require 'rails_helper'

RSpec.describe Event do
  subject(:event) { build :event }

  it { is_expected.to be_valid }
  it { is_expected.to validate_presence_of :name }
  it { is_expected.to validate_numericality_of(:max_sellers).is_greater_than(0) }
  it { is_expected.to have_many(:reservations).dependent(:destroy) }
  it { is_expected.to have_many(:notifications).dependent(:destroy) }
  it { is_expected.to have_many(:reviews).dependent(:destroy) }

  describe '#to_s' do
    its(:to_s) { is_expected.to eq subject.name }

    context 'without name' do
      subject { Event.new }

      it 'calls superclass' do
        expect(subject.to_s).to eq(subject.class.superclass.instance_method(:to_s).bind(subject).call)
      end
    end
  end

  describe '#reservable' do
    let!(:seller) { create :seller }

    let!(:event_with_ongoing_reservation) do
      create :event_with_ongoing_reservation, name: 'reservable_event'
    end
    let!(:event_with_wrong_reservation_time) do
      create :event, name: 'wrong_time', reservation_start: 1.day.from_now, reservation_end: 2.days.from_now
    end
    let!(:event_with_full_reservations) { create :full_event, name: 'full' }
    let!(:reservation_for_full_event) { create :reservation, event: event_with_full_reservations }

    let!(:event_with_reservation_for_seller) do
      create :event, name: 'already_reserved', max_sellers: 2,
                     reservation_start: 1.day.ago, reservation_end: 1.day.from_now
    end
    let!(:reservation) { create :reservation, event: event_with_reservation_for_seller, seller: seller }
    it 'lists only reservable events' do
      expect(Event.reservable_by(seller).length).to eq 1
      expect(Event.reservable_by(seller)).to include event_with_ongoing_reservation
    end
  end

  describe '#kind' do
    its(:commissioned?) { is_expected.to be true }

    context 'when commissioned' do
      before { subject.commissioned! }

      its(:kind) { is_expected.to eq 'commissioned' }
      its(:commissioned?) { is_expected.to be true }
    end

    context 'when direct' do
      before { subject.direct! }

      its(:kind) { is_expected.to eq 'direct' }
      its(:direct?) { is_expected.to be true }
    end
  end

  describe '#reviewed_by?' do
    let(:seller) { build :seller }
    context 'when reviewed by seller' do
      before { subject.reviews << build(:review, event: subject, seller: seller) }
      it 'is reviewed by seller' do
        expect(subject.reviewed_by? seller).to be true
      end
    end

    context 'when not reviewed by seller' do
      it 'is not reviewed by seller' do
        expect(subject.reviewed_by? seller).to be false
      end
    end
  end

  describe '#past?' do
    subject { event.past? }
    it { is_expected.to eq false }

    context 'when shopping time is in the past' do
      let(:event) { build :event, shopping_time: 1.day.ago }
      it { is_expected.to eq true }
    end
  end

  describe '#token' do
    before { subject.save }
    its(:token) { is_expected.not_to be_nil }
  end

  describe '#top_sellers' do
    let(:event) { create :event_with_ongoing_reservation }
    let!(:reservation1) { create :reservation, event: event }
    let!(:reservation2) { create :reservation, event: event }
    subject { event.top_sellers }
    before do
      create_list :sold_item, 5, reservation: reservation1
      create_list :sold_item, 3, reservation: reservation2
    end

    it { is_expected.to include reservation1.number => 5, reservation2.number => 3 }
  end
end
