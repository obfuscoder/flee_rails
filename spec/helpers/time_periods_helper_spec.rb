require 'rails_helper'

RSpec.describe TimePeriodsHelper do
  describe '#period' do
    subject { helper.period argument, options }

    let(:min) { Time.zone.local(2007, 2, 10, 15, 30) }
    let(:max) { min + 2.hours }
    let(:period) { double min: min, max: max }
    let(:options) { {} }
    let(:argument) { [period] }

    it { is_expected.to eq 'Sa, 10. Februar 2007 15:30 - 17:30 Uhr' }

    context 'when periods are empty' do
      let(:argument) { [] }

      it { is_expected.to eq '' }
    end

    context 'when max is on a different day' do
      let(:max) { min + 1.day + 2.hours }

      it { is_expected.to eq 'Sa, 10. Februar 2007, 15:30 Uhr bis So, 11. Februar 2007, 17:30 Uhr' }
    end

    context 'with additional period on the same day' do
      let(:min2) { max + 2.hours }
      let(:max2) { min2 + 2.hours }
      let(:period2) { double min: min2, max: max2 }
      let(:argument) { [period, period2] }

      it { is_expected.to eq 'Sa, 10.02.2007 15:30 - 17:30 und 19:30 - 21:30 Uhr' }

      context 'with additional period on the next day' do
        let(:min3) { min + 1.day }
        let(:max3) { min3 + 2.hours }
        let(:period3) { double min: min3, max: max3 }
        let(:argument) { [period, period2, period3] }

        it do
          is_expected.to eq 'Sa, 10.02.2007 15:30 - 17:30 und 19:30 - 21:30 Uhr und So, 11.02.2007 15:30 - 17:30 Uhr'
        end
      end
    end

    context 'with additional period on the next day' do
      let(:min2) { min + 1.day }
      let(:max2) { min2 + 2.hours }
      let(:period2) { double min: min2, max: max2 }
      let(:argument) { [period, period2] }

      it { is_expected.to eq 'Sa, 10.02.2007 15:30 - 17:30 Uhr und So, 11.02.2007 15:30 - 17:30 Uhr' }
    end

    context 'when option exact is false' do
      let(:options) { { exact: false } }

      it { is_expected.to eq 'Februar 2007' }
    end
  end
end
