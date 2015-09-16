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

  describe '#create_code' do
    let(:options) { {} }
    let(:preparations) {}
    let(:reservation) { FactoryGirl.create :reservation }
    subject { FactoryGirl.build :item, reservation: reservation }
    before do
      preparations
      subject.create_code options
    end

    its(:code) { is_expected.to eq '010010012' }
    its(:number) { is_expected.to eq 1 }

    context 'when other item is numbered already' do
      let(:preparations) { FactoryGirl.create :item, reservation: reservation, number: 4, code: 'abcd1234' }
      its(:number) { is_expected.to eq 5 }
    end

    context 'with prefix option' do
      let(:options) { { prefix: 'ABC' } }
      its(:code) { is_expected.to eq 'ABC010010012' }
    end
  end
end
