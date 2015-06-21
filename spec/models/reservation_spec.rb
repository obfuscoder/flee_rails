require 'rails_helper'

RSpec.describe Reservation do
  subject { FactoryGirl.build(:reservation) }

  it { is_expected.to be_valid }
  it { is_expected.to validate_presence_of(:seller) }
  it { is_expected.to validate_presence_of(:event) }
  it { is_expected.to validate_numericality_of(:number).is_greater_than(0).only_integer }
  it { is_expected.to validate_uniqueness_of(:number).scoped_to(:event_id) }
  it { is_expected.to validate_uniqueness_of(:seller_id).scoped_to(:event_id) }
  it { is_expected.to have_many(:items).dependent(:destroy) }
  it { is_expected.to belong_to(:event) }
  it { is_expected.to belong_to(:seller) }
  its(:to_s) { is_expected.to eq("#{subject.event.name} - #{subject.number}") }
end
