require 'rails_helper'
require 'support/shared_examples_for_views'

RSpec.describe 'sellers/edit' do
  let(:seller) { FactoryGirl.create(:seller) }
  before do
    assign(:seller, seller)
    render
  end

  it_behaves_like 'a standard view'

  it 'renders the seller edit form' do
    expect(view).to render_template partial: 'sellers/_form'
  end

  it 'allows to go back to seller home page' do
    assert_select 'a[href=?]', seller_path
  end

  context 'when seller has disabled mails' do
    xit 'allows to enable mail notificatios' do
      assert_select 'a[href=?]', enable_mail_seller_path
    end
  end

  context 'when seller has enabled mails' do
    xit 'allows to disable mail notificatios' do
      assert_select 'a[href=?]', disable_mail_seller_path
    end
  end
end
