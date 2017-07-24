# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Review do
  subject { build(:review) }

  it { is_expected.to be_valid }
  it { is_expected.to validate_presence_of(:reservation) }
  it { is_expected.to validate_uniqueness_of(:reservation_id) }
  it { is_expected.to belong_to(:reservation) }
end
