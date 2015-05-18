require 'rails_helper'

RSpec.describe Item do
  subject { FactoryGirl.build(:item) }
  it { should be_valid }
  it { should validate_presence_of(:seller) }
  it { should validate_presence_of(:category) }
  it { should validate_presence_of(:description) }
  it { should validate_presence_of(:price) }
  it { should have_many(:labels).dependent(:destroy) }
  it { should belong_to(:category) }
  it { should belong_to(:seller) }

  describe '#to_s' do
    its(:to_s) { should eq(subject.description) }

    context 'without description' do
      subject { Item.new }

      it 'calls superclass' do
        expect(subject.to_s).to eq(subject.class.superclass.instance_method(:to_s).bind(subject).call)
      end
    end
  end
end
