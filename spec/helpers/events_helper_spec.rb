require 'rails_helper'

RSpec.describe EventsHelper do
  %w(shopping handover pickup).each do |kind|
    describe "##{kind}_time" do
      let(:min) { Time.zone.local(2007, 2, 10, 15, 30) }
      let(:max) { min + 2.hours }
      let(:event) { FactoryGirl.build :event, confirmed: true }
      subject { helper.send("#{kind}_time", event) }
      it 'calls time periods helper method' do
        parameter = event.send "#{kind}_periods"
        expect_any_instance_of(TimePeriodsHelper).to receive(:period).with(parameter, exact: true) { 'XXX' }
        expect(subject).to eq 'XXX'
      end
    end
  end
end