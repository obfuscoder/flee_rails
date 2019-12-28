require 'rails_helper'

RSpec.describe SupportType do
  subject(:support_type) { build :support_type }

  it { is_expected.to be_valid }
  it { is_expected.to belong_to :event }
  it { is_expected.to have_many :supporters }
  it { is_expected.to validate_presence_of :name }
  it { is_expected.to validate_presence_of :capacity }
  it { is_expected.to validate_numericality_of(:capacity).is_greater_than 0 }
end
