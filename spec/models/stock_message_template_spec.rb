# frozen_string_literal: true

require 'rails_helper'

RSpec.describe StockMessageTemplate do
  subject(:stock_message_template) { described_class.first }

  it { is_expected.to be_valid }
  it { is_expected.to validate_presence_of :category }
  it { is_expected.to validate_uniqueness_of(:category) }
  it { is_expected.to validate_presence_of :subject }
  it { is_expected.to validate_presence_of :body }
end
