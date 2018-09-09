# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'admin/emails/show' do
  let(:email) { build :email }

  before { assign :email, email }

  it_behaves_like 'a standard view'

  describe 'rendered' do
    subject { rendered }

    before { render }

    it { is_expected.to have_content email.to }
    it { is_expected.to have_content email.from }
    it { is_expected.to have_content email.body }
  end
end
