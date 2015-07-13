require 'rails_helper'

RSpec.describe 'admin/sellers/index' do
  let(:sellers) { FactoryGirl.create_list :seller, 25 }
  before do
    assign :sellers, sellers.paginate
    render
  end

  it_behaves_like 'a standard view'

  it 'allows to sort by email address' do
    expect(rendered).to have_link 'eMail-Adresse', href: admin_sellers_path(sort: :email, dir: :asc)
  end

  it 'allows to sort by name' do
    expect(rendered).to have_link 'Name', href: admin_sellers_path(sort: :name, dir: :desc)
  end
end
