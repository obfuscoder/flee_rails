require 'rails_helper'
require 'support/shared_examples_for_views'

RSpec.describe 'sellers/edit' do
  before(:each) do
    @seller = assign(:seller, FactoryGirl.create(:seller))
  end

  it_behaves_like 'a standard view'

  it 'renders the edit seller form' do
    render

    assert_select 'form[action=?][method=?]', seller_path, 'post' do
      assert_select 'input#seller_first_name[name=?]', 'seller[first_name]'
      assert_select 'input#seller_last_name[name=?]', 'seller[last_name]'
      assert_select 'input#seller_street[name=?]', 'seller[street]'
      assert_select 'input#seller_zip_code[name=?]', 'seller[zip_code]'
      assert_select 'input#seller_city[name=?]', 'seller[city]'
      assert_select 'input#seller_email[name=?]', 'seller[email]'
      assert_select 'input#seller_phone[name=?]', 'seller[phone]'
      assert_select 'input#seller_accept_terms[name=?]', 'seller[accept_terms]', count: 0
    end
  end
end
