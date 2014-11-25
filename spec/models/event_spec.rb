require 'rails_helper'

RSpec.describe Event do
  subject { FactoryGirl.build :event }

  it { should be_valid }
  it { should validate_presence_of :name }
  it { should validate_numericality_of(:max_sellers).is_greater_than(0).only_integer }
  it { should have_many(:reservations).dependent(:destroy) }
  it { should have_many(:notifications).dependent(:destroy) }
  it { should have_many(:reviews).dependent(:destroy) }

  describe "#to_s" do
    its(:to_s) { should eq subject.name }

    context "without name" do
      subject { Event.new }

      it "calls superclass" do
        expect(subject.to_s).to eq(subject.class.superclass.instance_method(:to_s).bind(subject).call)
      end
    end
  end

  describe '#reservable' do
    let!(:seller) { FactoryGirl.create :seller }

    let!(:event_with_ongoing_reservation) { FactoryGirl.create :event_with_ongoing_reservation,
                                                               name: 'reservable_event' }
    let!(:event_with_wrong_reservation_time) { FactoryGirl.create :event, name: 'wrong_time',
                                                                  reservation_start: 1.day.from_now,
                                                                  reservation_end: 2.days.from_now }
    let!(:event_with_full_reservations) { FactoryGirl.create :full_event, name: 'full' }
    let!(:reservation_for_full_event) { FactoryGirl.create :reservation, event: event_with_full_reservations }

    let!(:event_with_reservation_for_seller) { FactoryGirl.create :event, name: 'already_reserved',
                                                                  max_sellers: 2,
                                                                  reservation_start: 1.day.ago,
                                                                  reservation_end: 1.day.from_now }
    let!(:reservation) { FactoryGirl.create :reservation, event: event_with_reservation_for_seller, seller: seller }
    it 'lists only reservable events' do
      expect(Event.reservable_by(seller).length).to eq 1
      expect(Event.reservable_by(seller)).to include event_with_ongoing_reservation
    end
  end

  describe '#kind' do
    context 'when commission' do
      before { subject.commission! }

      its(:kind) { is_expected.to eq 'commission' }
      its(:commission?) { is_expected.to be true }
    end

    context 'when direct' do
      before { subject.direct! }

      its(:kind) { is_expected.to eq 'direct' }
      its(:direct?) { is_expected.to be true }
    end
  end

  describe '#reviewed_by?' do
    let(:seller) { FactoryGirl.build :seller }
    context 'when reviewed by seller' do
      before { subject.reviews << FactoryGirl.build(:review, event: subject, seller: seller) }
      it "is reviewed by seller" do
        expect(subject.reviewed_by? seller).to be true
      end
    end

    context 'when not reviewed by seller' do
      it "is not reviewed by seller" do
        expect(subject.reviewed_by? seller).to be false
      end
    end
  end
end
