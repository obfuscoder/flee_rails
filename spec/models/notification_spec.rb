require 'rails_helper'

RSpec.describe Notification do
  subject { FactoryGirl.build(:notification) }

  it { is_expected.to be_valid }
  it { is_expected.to validate_presence_of(:event) }
  it { is_expected.to validate_presence_of(:seller) }
  it { is_expected.to validate_uniqueness_of(:seller_id).scoped_to(:event_id) }
  it { is_expected.to belong_to(:event) }
  it { is_expected.to belong_to(:seller) }
end
