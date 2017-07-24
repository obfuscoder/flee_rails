# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'sellers/resend_activation' do
  before do
    @seller = assign(:seller, Seller.new)
  end

  it_behaves_like 'a standard view'

  it 'renders a resend activation form' do
    render
    assert_select 'form[method=post]' do
      assert_select +'input#seller_email[name=?]', 'seller[email]'
      assert_select +'input#seller_email[name=?]', 'seller[email]'
      assert_select +'input[type=submit][value=?]', 'Erneut zusenden'
    end
  end
end
