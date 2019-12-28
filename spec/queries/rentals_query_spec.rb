require 'rails_helper'

RSpec.describe RentalsQuery do
  subject(:instance) { described_class.new event }

  let(:event) { create :event }

  describe '#all' do
    subject(:action) { instance.all }

    let!(:rental) { create :rental, event: event }

    it { is_expected.to include rental }
  end

  describe '#rentable_hardware' do
    subject(:action) { instance.rentable_hardware }

    let!(:not_yet_rented_hardware) { create :hardware }
    let!(:already_rented_hardware) { create :hardware }
    let!(:rental) { create :rental, event: event, hardware: already_rented_hardware }

    it { is_expected.to include not_yet_rented_hardware }
    it { is_expected.not_to include already_rented_hardware }
  end

  describe '#new' do
    subject(:action) { instance.new }

    it { is_expected.to be_a_new(Rental) }
    it { is_expected.to have_attributes event: event }
  end

  describe '#create' do
    subject(:action) { instance.create hardware_id: hardware.id, amount: amount }

    let(:amount) { 3 }
    let(:hardware) { create :hardware }

    it { is_expected.to be_a(Rental).and(be_persisted).and(be_valid) }

    context 'when a rental could not be saved' do
      let!(:rental) { create :rental, event: event, hardware: hardware }

      it { is_expected.to be_a Rental }
      it { is_expected.not_to be_persisted }
      it { is_expected.not_to be_valid }
    end
  end

  describe '#find' do
    subject(:action) { instance.find(rental.id) }

    let(:rental) { create :rental, event: event }

    it { is_expected.to eq rental }

    context 'when id belongs to rental for a different event' do
      let(:rental) { create :rental }

      it 'raises error' do
        expect { action }.to raise_error ActiveRecord::RecordNotFound
      end
    end
  end

  describe '#update' do
    subject(:action) { instance.update rental.id, amount: amount }

    let(:amount) { 11 }
    let(:rental) { create :rental, event: event }

    it { is_expected.to eq rental }
    it { is_expected.to be_valid.and(be_persisted) }
    it { is_expected.to have_attributes amount: amount }
  end
end
