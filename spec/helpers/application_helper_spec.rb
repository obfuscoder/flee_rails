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

    context 'when event not confirmed' do
      let(:confirmed) { false }
      it { is_expected.to eq 'Februar 2007' }
    end
  end
end
