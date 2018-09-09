# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Supporter do
  subject(:supporter) { build :supporter }

  it { is_expected.to be_valid }
  it { is_expected.to belong_to :support_type }
  it { is_expected.to belong_to :seller }
  it { is_expected.to validate_uniqueness_of(:seller).scoped_to(:support_type_id) }
  it { is_expected.to validate_presence_of(:seller) }
end
