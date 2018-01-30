# frozen_string_literal: true

require 'rails_helper'

RSpec.describe MessageTemplate do
  subject(:message_template) { build :message_template }

  it { is_expected.to belong_to :client }
  it { is_expected.to be_valid }
  it { is_expected.to validate_presence_of :category }
  it { is_expected.to validate_uniqueness_of(:category).scoped_to(:client_id) }
  it { is_expected.to validate_presence_of :subject }
  it { is_expected.to validate_presence_of :body }
end
