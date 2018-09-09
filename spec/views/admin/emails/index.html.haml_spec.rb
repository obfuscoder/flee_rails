# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'admin/emails/index' do
  let(:emails) { create_list :email, 5, seller: seller }
  let(:seller) { create :seller }

  before { assign :emails, emails.paginate }

  before { assign :seller, seller }

  it_behaves_like 'a standard view'

  it 'links to show each email' do
    render
    emails.each do |email|
      expect(rendered).to have_link href: admin_seller_email_path(seller, email)
    end
  end

  it 'shows email basics' do
    render
    emails.each do |email|
      expect(rendered).to have_content email.from
      expect(rendered).to have_content email.subject
    end
  end
end
