require 'rails_helper'

RSpec.describe Event do
  subject(:event) { build :event }

  it { is_expected.to be_valid }
  it { is_expected.to validate_presence_of :client }
  it { is_expected.to validate_presence_of :name }
  it { is_expected.to validate_presence_of :reservation_start }
  it { is_expected.to validate_presence_of :reservation_end }
  it { is_expected.to validate_numericality_of(:max_reservations).is_greater_than 0 }
  it { is_expected.to belong_to :client }
  it { is_expected.to have_many :reservations }
  it { is_expected.to have_many :support_types }
  it { is_expected.to have_many(:reviews).through(:reservations) }
  it { is_expected.to have_many(:items).through(:reservations) }
  it { is_expected.to have_many :notifications }
  it { is_expected.to have_many :suspensions }
  it { is_expected.to have_many :rentals }
  it { is_expected.to have_many(:stock_items).through(:sold_stock_items) }
  it { is_expected.to validate_numericality_of(:number).is_greater_than(0) }
  it { is_expected.to validate_uniqueness_of(:number).scoped_to(:client_id) }

  describe '#to_s' do
    its(:to_s) { is_expected.to eq event.name }

    context 'without name' do
      subject(:instance) { described_class.new }

      it 'calls superclass' do
        expect(instance.to_s).to eq(instance.class.superclass.instance_method(:to_s).bind(instance).call)
      end
    end
  end

  describe '#reservable' do
    let!(:event_with_ongoing_reservation) do
      create :event_with_ongoing_reservation, name: 'reservable_event'
    end
    let!(:event_with_wrong_reservation_time) do
      create :event, name: 'wrong_time', reservation_start: 1.day.from_now, reservation_end: 2.days.from_now
    end
    let!(:event_with_full_reservations) { create :full_event, name: 'full' }
    let!(:reservation_for_full_event) { create :reservation, event: event_with_full_reservations }

    it 'lists only reservable events' do
      expect(described_class.reservable.length).to eq 1
      expect(described_class.reservable).to include event_with_ongoing_reservation
    end
  end

  describe '#reservable_by?' do
    subject { event.reservable_by? seller }

    let(:event) { create :event_with_ongoing_reservation }
    let(:seller) { create :seller }

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

    context 'when seller is suspended for the event' do
      before { create :suspension, event: event, seller: seller }

      it { is_expected.to eq false }
    end

    context 'when reservation by seller is forbidden' do
      let(:client) { create :client, reservation_by_seller_forbidden: true }
      let(:event) { create :event_with_ongoing_reservation, client: client }
      let(:seller) { create :seller, client: client }

      it { is_expected.to eq false }
    end
  end

  describe '#kind' do
    its(:commissioned?) { is_expected.to be true }

    context 'when commissioned' do
      before { event.commissioned! }

      its(:kind) { is_expected.to eq 'commissioned' }
      its(:commissioned?) { is_expected.to be true }
    end

    context 'when direct' do
      before { event.direct! }

      its(:kind) { is_expected.to eq 'direct' }
      its(:direct?) { is_expected.to be true }
    end
  end

  describe '#reviewed_by?' do
    let(:seller) { build :seller }

    context 'when reviewed by seller' do
      let(:reservation) do
        build(:reservation, event: event, seller: seller).tap(&:build_review)
      end

      before { event.reservations << reservation }

      it 'is reviewed by seller' do
        expect(event.reviewed_by?(seller)).to eq true
      end
    end

    context 'when not reviewed by seller' do
      it 'is not reviewed by seller' do
        expect(event.reviewed_by?(seller)).to eq false
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
    before { event.save }

    its(:token) { is_expected.not_to be_nil }
  end

  describe '#top_sellers' do
    subject { event.top_sellers }

    let(:event) { create :event_with_ongoing_reservation }
    let(:reservation1) { create :reservation, event: event }
    let(:reservation2) { create :reservation, event: event }
    let(:reservation3) { create :reservation, event: event }

    before do
      create_list :sold_item, 5, reservation: reservation1
      create_list :sold_item, 3, reservation: reservation2
      create_list :sold_item, 10, reservation: reservation3
    end

    it { is_expected.to eq [[reservation3.number, 10], [reservation1.number, 5], [reservation2.number, 3]] }
  end

  describe 'item counts' do
    let(:item_count) { 5 }
    let(:event) { create :event_with_ongoing_reservation, number: 5 }
    let(:reservation) { create :reservation, event: event }
    let!(:items) { create_list :item, item_count, reservation: reservation }

    describe '#item_count' do
      subject { event.item_count }

      it { is_expected.to eq item_count }
    end

    describe '#sold_item_count' do
      subject { event.sold_item_count }

      let(:sold_item_count) { 3 }
      let!(:sold_items) { create_list :sold_item, sold_item_count, reservation: reservation }

      it { is_expected.to eq sold_item_count }
    end

    describe '#checked_in_item_count' do
      subject { event.checked_in_item_count }

      let(:count) { 3 }
      let!(:items) { create_list :checked_in_item, count, reservation: reservation }

      it { is_expected.to eq count }
    end

    describe '#checked_out_item_count' do
      subject { event.checked_out_item_count }

      let(:count) { 3 }
      let!(:items) { create_list :checked_out_item, count, reservation: reservation }

      it { is_expected.to eq count }
    end

    describe '#items_with_label_count' do
      subject { event.items_with_label_count }

      let(:items_with_label_count) { 2 }
      let!(:items_with_label) { create_list :item_with_code, items_with_label_count, reservation: reservation }

      it { is_expected.to eq items_with_label_count }
    end

    describe '#sold_item_percentage' do
      subject { event.sold_item_percentage }

      let(:sold_item_count) { 5 }
      let!(:sold_items) { create_list :sold_item, sold_item_count, reservation: reservation }

      it { is_expected.to eq 50 }
    end

    describe '#sold_item_sum' do
      subject { event.sold_item_sum }

      let(:price) { 3.5 }
      let(:sold_item_count) { 3 }
      let!(:sold_items) { create_list :sold_item, sold_item_count, price: price, reservation: reservation }
      let(:stock_items) { create_list :stock_item, 4, price: price }
      let!(:sold_stock_items) do
        stock_items.map { |e| create :sold_stock_item, stock_item: e, event: event, amount: 2 }
      end

      it { is_expected.to eq 38.5 }
    end

    describe '#reservation_fees_sum' do
      subject { event.reservation_fees_sum }

      let!(:reservation2) { create :reservation, event: event, fee: 10 }

      it { is_expected.to eq 12 }
    end

    describe '#revenue' do
      subject { event.revenue }

      let!(:reservation2) { create :reservation, event: event, fee: 10 }
      let(:price) { 3.5 }
      let(:sold_item_count) { 3 }
      let!(:sold_items) { create_list :sold_item, sold_item_count, price: price, reservation: reservation }
      let(:stock_items) { create_list :stock_item, 4, price: price }
      let!(:sold_stock_items) do
        stock_items.map { |e| create :sold_stock_item, stock_item: e, event: event, amount: 2 }
      end

      it { is_expected.to eq 50.5 }
    end

    describe '#system_fees' do
      subject { event.system_fees }

      let!(:reservation2) { create :reservation, event: event, fee: 10 }
      let(:price) { 3.5 }
      let(:sold_item_count) { 3 }
      let!(:sold_items) { create_list :sold_item, sold_item_count, price: price, reservation: reservation }
      let(:stock_items) { create_list :stock_item, 4, price: price }
      let!(:sold_stock_items) do
        stock_items.map { |e| create :sold_stock_item, stock_item: e, event: event, amount: 2 }
      end

      it { is_expected.to eq 0.505 }
    end

    describe '#rental_fees' do
      subject { event.rental_fees }

      let!(:scanner) { create :rental, event: event, hardware: create(:scanner), amount: 2 }
      let!(:router) { create :rental, event: event, hardware: create(:router) }

      it { is_expected.to eq 15 }
    end

    describe '#total_fees' do
      subject { event.total_fees }

      let!(:reservation2) { create :reservation, event: event, fee: 10 }
      let(:price) { 3.5 }
      let(:sold_item_count) { 3 }
      let!(:sold_items) { create_list :sold_item, sold_item_count, price: price, reservation: reservation }
      let(:stock_items) { create_list :stock_item, 4, price: price }
      let!(:sold_stock_items) do
        stock_items.map { |e| create :sold_stock_item, stock_item: e, event: event, amount: 2 }
      end
      let!(:scanner) { create :rental, event: event, hardware: create(:scanner), amount: 2 }
      let!(:router) { create :rental, event: event, hardware: create(:router) }

      it { is_expected.to eq 15.505 }
    end
  end

  describe '#sold_stock_item_count' do
    subject { event.sold_stock_item_count }

    let(:event) { create :event }
    let!(:sold_stock_items) { create_list :sold_stock_item, 3, event: event, amount: 2 }

    before { event.reload }

    it { is_expected.to eq 6 }
  end

  describe '#items_per_category' do
    subject { event.items_per_category }

    let(:event) { create :event_with_ongoing_reservation }
    let(:reservation) { create :reservation, event: event }
    let(:category1) { create :category }
    let(:category2) { create :category }
    let!(:items1) { create_list :item, 4, reservation: reservation, category: category1 }
    let!(:items2) { create_list :item, 3, reservation: reservation, category: category2 }

    it { is_expected.to eq [[category1.name, items1.count], [category2.name, items2.count]] }
  end

  describe '#sold_items_per_category' do
    subject { event.sold_items_per_category }

    let(:event) { create :event_with_ongoing_reservation }
    let(:reservation) { create :reservation, event: event }
    let(:category1) { create :category }
    let(:category2) { create :category }
    let(:category3) { create :category }
    let!(:items1) { create_list :sold_item, 4, reservation: reservation, category: category1 }
    let!(:items2) { create_list :sold_item, 3, reservation: reservation, category: category2 }
    let!(:items3) { create_list :item, 2, reservation: reservation, category: category3 }

    it { is_expected.to eq [[category1.name, items1.count], [category2.name, items2.count]] }
  end

  describe '#max_reservations_per_seller' do
    subject { event.max_reservations_per_seller }

    it { is_expected.to eq 1 }
  end

  describe '#in_need_of_support' do
    subject { described_class.in_need_of_support }

    let!(:event_without_support) { create :event }
    let!(:event_with_support) { create :event_with_support }
    let!(:event_with_support_full) { create :event_with_support_full }
    let!(:event_with_support_disabled) { create :event_with_support, support_system_enabled: false }

    it { is_expected.not_to include event_without_support }
    it { is_expected.to include event_with_support }
    it { is_expected.not_to include event_with_support_full }
    it { is_expected.not_to include event_with_support_disabled }
  end
end
