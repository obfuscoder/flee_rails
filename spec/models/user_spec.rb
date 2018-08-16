# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User do
  subject { build :user }

  it { is_expected.to be_valid }
  it { is_expected.to belong_to :client }
  it { is_expected.to validate_presence_of :client }
  it { is_expected.to validate_uniqueness_of(:email).scoped_to(:client_id) }
end
