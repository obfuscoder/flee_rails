require 'rails_helper'

RSpec.describe Notification do
  subject { FactoryGirl.build(:notification) }

  it { should be_valid }
  it { should validate_presence_of(:event) }
  it { should validate_presence_of(:seller) }
  it { should validate_uniqueness_of(:seller_id).scoped_to(:event_id) }
  it { should belong_to(:event) }
  it { should belong_to(:seller) }
end
