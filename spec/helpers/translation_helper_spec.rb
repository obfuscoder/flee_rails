require 'rails_helper'

RSpec.describe TranslationHelper do
  describe '#localize' do
    subject { helper.localize time, format: :short }

    let(:time) { Time.zone.local 2007, 2, 10, 15, 30 }

    it { is_expected.to eq '10.02.2007 15:30' }

    context 'with nil time' do
      let(:time) { nil }

      it { is_expected.to eq '' }
    end
  end
end
