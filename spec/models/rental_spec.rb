require 'rails_helper'

RSpec.describe Rental do
  subject(:rental) { build :rental }

  it { is_expected.to be_valid }
  it { is_expected.to belong_to :event }
  it { is_expected.to belong_to :hardware }

  it { is_expected.to validate_presence_of :event }
  it { is_expected.to validate_presence_of :hardware }
  it { is_expected.to validate_presence_of :amount }
  it { is_expected.to validate_numericality_of(:amount).is_greater_than 0 }
  it { is_expected.to validate_uniqueness_of(:hardware).scoped_to :event_id }
end
