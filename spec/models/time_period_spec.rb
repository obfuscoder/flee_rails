require 'rails_helper'

RSpec.describe TimePeriod do
  subject { build :time_period }
  it { is_expected.to be_valid }
  context 'when max is before min' do
    subject(:time_period) { build :time_period, max: 1.day.ago, min: 1.hour.ago }
    it { is_expected.not_to be_valid }
    context 'when validated' do
      before { time_period.valid? }
      describe 'its error messages' do
        subject(:messages) { time_period.errors.messages }
        it { is_expected.to have_key :max }
        describe 'error message for max' do
          subject { messages[:max][0] }
          it { is_expected.not_to include 'translation missing' }
        end
      end
    end
  end
end
