# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Hardware do
  subject(:hardware) { build :hardware }

  it { is_expected.to be_valid }
  it { is_expected.to validate_presence_of :description }
  it { is_expected.to validate_uniqueness_of :description }
  it { is_expected.to validate_presence_of :price }
  it { is_expected.to validate_numericality_of(:price).is_greater_than(0) }
  it { is_expected.to have_many :rentals }
end
