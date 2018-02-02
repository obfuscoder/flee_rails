# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Transaction do
  subject(:transaction) { build :transaction }

  it { is_expected.to be_valid }
  it { is_expected.to belong_to :event }
  it { is_expected.to validate_presence_of :event }
  it { is_expected.to validate_presence_of :kind }
  it { is_expected.to validate_presence_of :number }
  it { is_expected.to validate_uniqueness_of(:number).scoped_to(:event_id) }
end
