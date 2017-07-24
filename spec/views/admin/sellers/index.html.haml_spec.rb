# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'admin/sellers/index' do
  let(:sellers) { create_list :seller, 25 }
  before do
    assign :sellers, sellers.paginate
  end

  it_behaves_like 'a standard view'

  it 'has column sort links' do
    expect_any_instance_of(ApplicationHelper).to receive(:sort_link_to).with(Seller, :name)
    expect_any_instance_of(ApplicationHelper).to receive(:sort_link_to).with(Seller, :email)
    render
  end
end
