require 'rails_helper'

RSpec.describe 'admin/users/_form' do
  let(:user) { build :user }
  let(:preparations) {}

  before do
    preparations
    assign :user, user
  end

  it_behaves_like 'a standard partial'

  describe 'rendered' do
    subject { rendered }

    before { render }

    it { is_expected.to have_field 'user_name' }
    it { is_expected.to have_field 'user_email' }
  end
end
