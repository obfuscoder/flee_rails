# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Bill do
  subject(:bill) { event.create_bill }

  let(:event) { create :billable_event, number: event_number }
  let(:event_number) { 10 }

  it { is_expected.to be_valid }
  it { is_expected.to belong_to(:event) }
  it { is_expected.to validate_uniqueness_of(:number).ignoring_case_sensitivity }

  describe '#from_address' do
    subject(:action) { bill.from_address }

    it { is_expected.to eq "Lehmann Softwarelösungen\nEssenweinstraße 19\n76131 Karlsruhe" }
  end

  describe '#address' do
    subject(:action) { bill.address }

    it { is_expected.to eq "Maria Mustermann\nBeispielstraße 123\n54321 Musterstadt" }
  end

  describe '#date' do
    subject(:action) { bill.date }

    it { is_expected.to eq Date.today }
  end

  describe '#number' do
    subject(:action) { bill.number }

    it { is_expected.to eq Date.today.strftime '%Y%m001' }

    context 'when other bills have been created this month already' do
      before { 2.times { create(:billable_event).create_bill } }

      it { is_expected.to eq Date.today.strftime '%Y%m003' }
    end
  end

  describe '#delivery_date' do
    subject(:action) { bill.delivery_date }

    it { is_expected.to eq event.shopping_periods.last.max.to_date }
  end

  describe '#items' do
    subject(:action) { bill.items }

    its(:first) do
      is_expected.to have_attributes description: 'Nutzungslizenzgebühr',
                                     price: 21.0,
                                     amount: '1 %',
                                     sum: 0.21
    end

    context 'when event is first for client' do
      let(:event_number) { 1 }

      its(:first) do
        is_expected.to have_attributes description: 'Nutzungslizenzgebühr',
                                       price: 21,
                                       amount: 0,
                                       sum: 0
      end

      its(:second) do
        is_expected.to have_attributes description: 'Einrichtungsgebühr',
                                       price: 50,
                                       amount: 1,
                                       sum: 50
      end
    end

    it 'contains rentals' do
      event.rentals.each_with_index do |rental, index|
        item = action[index + 1]
        expect(item).to have_attributes description: "Verleih #{rental.hardware.description}",
                                        price: 5.0,
                                        amount: rental.amount,
                                        sum: 5.0 * rental.amount
      end
    end
  end

  describe '#total' do
    subject(:action) { bill.total }

    it { is_expected.to eq 30.21 }

    context 'when event is first for client' do
      let(:event_number) { 1 }

      it { is_expected.to eq 80 }
    end
  end
end
