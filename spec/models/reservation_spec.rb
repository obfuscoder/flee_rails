require 'rails_helper'

RSpec.describe Reservation do
  subject { FactoryGirl.build(:reservation) }

  it { should be_valid }
  it { should validate_presence_of(:seller) }
  it { should validate_presence_of(:event) }
  it { should validate_numericality_of(:number).is_greater_than(0).only_integer }
  it { should validate_uniqueness_of(:number).scoped_to(:event_id) }
  it { should validate_uniqueness_of(:seller_id).scoped_to(:event_id) }
  it { should have_many(:items).dependent(:destroy) }
  it { should belong_to(:event) }
  it { should belong_to(:seller) }
  its(:to_s) { should eq("#{subject.event.name} - #{subject.number}") }
end
