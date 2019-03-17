# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Size do
  subject(:size) { build :size }

  it { is_expected.to be_valid }
  it { is_expected.to belong_to :category }
  it { is_expected.to validate_presence_of :value }
  it { is_expected.to validate_uniqueness_of(:value).scoped_to(:category_id) }
  it { is_expected.to validate_length_of(:value).is_at_most(50) }

  describe '#to_s' do
    its(:to_s) { is_expected.to eq size.value }
  end
end
