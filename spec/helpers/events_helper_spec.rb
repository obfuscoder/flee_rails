require 'rails_helper'

RSpec.describe EventsHelper do
  describe '#shopping_time' do
    let(:min) { Time.zone.local(2007, 2, 10, 15, 30) }
    let(:max) { min + 2.hours }
    let(:event) { FactoryGirl.build :event, shopping_start: min, shopping_end: max, confirmed: true }
    subject { helper.shopping_time event }
    it 'calls time periods helper method' do
      expect_any_instance_of(TimePeriodsHelper).to receive(:period).with(event.shopping_periods, exact: true) { 'XXX' }
      expect(subject).to eq 'XXX'
    end
  end
end
