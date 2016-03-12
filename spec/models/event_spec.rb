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
    it 'lists only reservable events' do
      expect(Event.reservable.length).to eq 1
      expect(Event.reservable).to include event_with_ongoing_reservation
    end
  end

  describe '#reservable_by?' do
    let(:event) { create :event_with_ongoing_reservation }
    let(:seller) { create :seller }
    subject { event.reservable_by? seller }
    context 'when seller has no reservation for the event' do
      it { is_expected.to eq true }
    end
    context 'when seller has reservation for the event' do
      before { create :reservation, event: event, seller: seller }
      it { is_expected.to eq false }
      context 'when event allows two reservations per seller' do
        let(:event) { create :event_with_ongoing_reservation, max_reservations_per_seller: 2 }
        it { is_expected.to eq true }
      end
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
        expect(subject.reviewed_by?(seller)).to be true
      end
    end

    context 'when not reviewed by seller' do
      it 'is not reviewed by seller' do
        expect(subject.reviewed_by?(seller)).to be false
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

    it { is_expected.to eq [[1, 5], [2, 3]] }
  end

  describe 'item counts' do
    let(:item_count) { 5 }
    let(:event) { create :event_with_ongoing_reservation }
    let(:reservation) { create :reservation, event: event }
    let!(:items) { create_list :item, item_count, reservation: reservation }

    describe '#item_count' do
      subject { event.item_count }
      it { is_expected.to eq item_count }
    end

    describe '#sold_item_count' do
      let(:sold_item_count) { 3 }
      let!(:sold_items) { create_list :sold_item, sold_item_count, reservation: reservation }
      subject { event.sold_item_count }
      it { is_expected.to eq sold_item_count }
    end

    describe '#items_with_label_count' do
      let(:items_with_label_count) { 2 }
      let!(:items_with_label) { create_list :item_with_code, items_with_label_count, reservation: reservation }
      subject { event.items_with_label_count }
      it { is_expected.to eq items_with_label_count }
    end

    describe '#sold_item_percentage' do
      let(:sold_item_count) { 5 }
      let!(:sold_items) { create_list :sold_item, sold_item_count, reservation: reservation }
      subject { event.sold_item_percentage }
      it { is_expected.to eq 50 }
    end

    describe '#sold_item_sum' do
      let(:price) { 3.50 }
      let(:sold_item_count) { 3 }
      let!(:sold_items) { create_list :sold_item, sold_item_count, price: price, reservation: reservation }
      subject { event.sold_item_sum }
      it { is_expected.to eq price * sold_item_count }
    end
  end

  describe '#items_per_category' do
    let(:event) { create :event_with_ongoing_reservation }
    let(:reservation) { create :reservation, event: event }
    let(:category1) { create :category }
    let(:category2) { create :category }
    let!(:items1) { create_list :item, 4, reservation: reservation, category: category1 }
    let!(:items2) { create_list :item, 3, reservation: reservation, category: category2 }

    subject { event.items_per_category }

    it { is_expected.to eq [[category1.name, items1.count], [category2.name, items2.count]] }
  end

  describe '#sold_items_per_category' do
    let(:event) { create :event_with_ongoing_reservation }
    let(:reservation) { create :reservation, event: event }
    let(:category1) { create :category }
    let(:category2) { create :category }
    let(:category3) { create :category }
    let!(:items1) { create_list :sold_item, 4, reservation: reservation, category: category1 }
    let!(:items2) { create_list :sold_item, 3, reservation: reservation, category: category2 }
    let!(:items3) { create_list :item, 2, reservation: reservation, category: category3 }

    subject { event.sold_items_per_category }

    it { is_expected.to eq [[category1.name, items1.count], [category2.name, items2.count]] }
  end
end
