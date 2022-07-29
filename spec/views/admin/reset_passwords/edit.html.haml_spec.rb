require 'rails_helper'

RSpec.describe 'admin/reset_passwords/edit' do
  let(:token) { 'token' }
  let(:user) { create :user }

  before do
    assign :token, token
    assign :user, user
  end

  it_behaves_like 'a standard view'

  describe 'rendered' do
    subject { rendered }

    before { render }

    it { is_expected.to have_field :user_password }
    it { is_expected.to have_field :user_password_confirmation }
  end
end
