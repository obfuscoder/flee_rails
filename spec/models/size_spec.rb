# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Size do
  subject(:size) { build :size }

  it { is_expected.to be_valid }
  it { is_expected.to belong_to :category }
  it { is_expected.to validate_presence_of :value }
  it { is_expected.to validate_uniqueness_of(:value).scoped_to(:category_id) }

  describe '#to_s' do
    its(:to_s) { is_expected.to eq subject.value }
  end
end
