require 'rails_helper'

RSpec.describe Event do
  subject { FactoryGirl.build(:event) }

  it { should be_valid }
  it { should validate_presence_of(:name) }
  it { should validate_numericality_of(:max_sellers).is_greater_than(0).only_integer }
  it { should have_many(:reservation).dependent(:destroy) }

  describe "#to_s" do
    its(:to_s) { should eq(subject.name) }

    context "without name" do
      subject { Event.new }

      it "calls superclass" do
        expect(subject.to_s).to eq(subject.class.superclass.instance_method(:to_s).bind(subject).call)
      end
    end
  end
end
