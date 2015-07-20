require 'rails_helper'

RSpec.describe ApplicationHelper do
  describe '#shopping_time' do
    let(:shopping_start) { Time.zone.local(2007, 2, 10, 15, 30) }
    let(:shopping_end) { shopping_start + 2.hours }
    let(:confirmed) { true }
    let(:event) do
      FactoryGirl.build :event, shopping_start: shopping_start, shopping_end: shopping_end, confirmed: confirmed
    end
    subject { helper.shopping_time event }

    it { is_expected.to eq 'Samstag, 10. Februar 2007 von 15:30 Uhr bis 17:30 Uhr' }

    context 'when shopping end is on a different day' do
      let(:shopping_end) { shopping_start + 1.day + 2.hours }
      it { is_expected.to eq 'Samstag, 10. Februar 2007, 15:30 Uhr bis Sonntag, 11. Februar 2007, 17:30 Uhr' }
    end

    context 'when event not confirmed' do
      let(:confirmed) { false }
      it { is_expected.to eq 'Februar 2007' }
    end
  end

  %w(localize l).each do |method|
    describe "##{method}" do
      let(:args) { Time.zone.local 2007, 2, 10, 15, 30 }
      subject { helper.send method, args }
      it { is_expected.to eq 'Samstag, 10. Februar 2007, 15:30 Uhr' }

      context 'when object is nil' do
        let(:args) { nil }
        it { is_expected.to eq '' }
      end
    end
  end
end
