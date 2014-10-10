require 'rails_helper'

RSpec.describe Category do
  subject { FactoryGirl.build(:category) }

  it { should be_valid }
  it { should validate_presence_of(:name) }
  it { should validate_uniqueness_of(:name) }
  it { should have_many(:item).dependent(:destroy) }

  describe "#to_s" do
    its(:to_s) { should eq(subject.name) }

    context "without name" do
      subject { Category.new }

      it "calls superclass" do
        expect(subject.to_s).to eq(subject.class.superclass.instance_method(:to_s).bind(subject).call)
      end
    end
  end
end
