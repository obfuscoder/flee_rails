require 'rails_helper'

RSpec.describe 'admin/sessions/new' do
  let(:user) { create :user }

  before { assign :user, user }

  it_behaves_like 'a standard view'

  describe 'rendered' do
    subject { rendered }

    before { render }

    it { is_expected.to have_field :user_email }
    it { is_expected.to have_field :user_password }
    it { is_expected.to have_link href: new_admin_reset_password_path }
  end
end
