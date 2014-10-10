require 'rails_helper'

RSpec.describe ReservedItem do
  subject { FactoryGirl.build(:reserved_item) }

  it { should be_valid }
  it { should validate_presence_of(:reservation) }
  it { should validate_presence_of(:item) }
  it { should validate_presence_of(:number) }
  it { should validate_presence_of(:code) }
  it { should validate_numericality_of(:number).is_greater_than(0).only_integer }
  it { should validate_uniqueness_of(:number).scoped_to(:reservation_id) }
  it { should validate_uniqueness_of(:item_id).scoped_to(:reservation_id) }
  it { should belong_to(:reservation) }
  it { should belong_to(:item) }
  its(:to_s) { should eq(subject.code) }
end
