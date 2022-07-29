require 'rails_helper'

RSpec.describe 'admin/reset_passwords/new' do
  it_behaves_like 'a standard view'

  describe 'rendered' do
    subject { rendered }

    before { render }

    it { is_expected.to have_field :reset_password_email }
  end
end
