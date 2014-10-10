require 'rails_helper'

RSpec.describe Seller do
  subject { FactoryGirl.build(:seller) }

  it { should be_valid }
  it { should validate_presence_of(:first_name) }
  it { should validate_presence_of(:last_name) }
  it { should validate_presence_of(:street) }
  it { should validate_presence_of(:zip_code) }
  it { should validate_presence_of(:city) }
  it { should validate_presence_of(:phone) }
  it { should validate_presence_of(:email) }
  it { should validate_uniqueness_of(:email) }
  it { should have_many(:item).dependent(:destroy) }
  it { should have_many(:reservation).dependent(:destroy) }
  its(:to_s) { should eq("#{subject.first_name} #{subject.last_name}") }
end
