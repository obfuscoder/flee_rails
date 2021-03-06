require 'rails_helper'

RSpec.describe CreateEventReport do
  subject(:instance) { described_class.new event }

  let(:event) { create :event_with_ongoing_reservation }
  let!(:categories) { create_list :category, 10, gender: true }
  let!(:reservations) { create_list :reservation, 5, event: event }
  let!(:items) do
    (0..49).map do
      create :item, reservation: reservations.sample, category: categories.sample, gender: Item.genders.keys.sample
    end
  end

  describe '#call' do
    subject(:action) { instance.call }

    it { is_expected.to be_a String }
    its(:lines) { is_expected.to have(items.count + 1).elements }

    describe 'first line' do
      subject(:first_line) { action.lines.first }

      it 'contains columns separated with tabs' do
        expect(first_line.split(/\t/)).to have(8).elements
      end
    end
  end
end
