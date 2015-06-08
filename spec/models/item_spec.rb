require 'rails_helper'

RSpec.describe Item do
  subject { FactoryGirl.build(:item) }
  it { is_expected.to be_valid }
  it { is_expected.to validate_presence_of(:reservation) }
  it { is_expected.to validate_presence_of(:category) }
  it { is_expected.to validate_presence_of(:description) }
  it { is_expected.to validate_presence_of(:price) }
  it { is_expected.to validate_numericality_of(:number).is_greater_than(0).only_integer }
  it { is_expected.to validate_uniqueness_of(:number).scoped_to(:reservation_id) }
  it { is_expected.to validate_uniqueness_of(:code) }
  it { is_expected.to belong_to(:category) }
  it { is_expected.to belong_to(:reservation) }

  describe '#to_s' do
    its(:to_s) { is_expected.to eq(subject.description) }

    context 'without description' do
      subject { Item.new }

      it 'calls superclass' do
        expect(subject.to_s).to eq(subject.class.superclass.instance_method(:to_s).bind(subject).call)
      end
    end
  end
end
