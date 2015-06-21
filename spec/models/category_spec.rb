require 'rails_helper'

RSpec.describe Category do
  subject { FactoryGirl.build(:category) }

  it { is_expected.to be_valid }
  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_uniqueness_of(:name) }
  it { is_expected.to have_many(:items).dependent(:destroy) }

  describe '#to_s' do
    its(:to_s) { is_expected.to eq subject.name }

    context 'without name' do
      subject { Category.new }

      it 'calls superclass' do
        expect(subject.to_s).to eq(subject.class.superclass.instance_method(:to_s).bind(subject).call)
      end
    end
  end
end
