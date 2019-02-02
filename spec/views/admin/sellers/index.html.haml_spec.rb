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

  it 'shows list of first 10 sellers with buttons for show, edit and delete' do
    render
    sellers.take(10).each do |seller|
      expect(rendered).to have_content seller.name
      expect(rendered).to have_content seller.email
      expect(rendered).to have_content seller.reservations.joins(:items).count
      expect(rendered).to have_link href: admin_seller_path(seller)
      expect(rendered).to have_link href: edit_admin_seller_path(seller)
      expect(rendered).to have_css "a[data-link='#{admin_seller_path(seller)}']"
    end
  end
end
