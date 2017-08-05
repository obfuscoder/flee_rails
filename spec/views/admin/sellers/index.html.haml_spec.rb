# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'admin/sellers/index' do
  let(:sellers) { create_list :seller, 25 }
  before { assign :sellers, sellers.paginate }

  it_behaves_like 'a standard view'

  it 'has column sort links' do
    expect_any_instance_of(ApplicationHelper).to receive(:sort_link_to).with(Seller, :name)
    expect_any_instance_of(ApplicationHelper).to receive(:sort_link_to).with(Seller, :email)
    render
  end

  it 'links to emails for each seller' do
    render
    sellers.take(10).each do |seller|
      expect(rendered).to have_link href: admin_seller_emails_path(seller)
    end
  end
end
