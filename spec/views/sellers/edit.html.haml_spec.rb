require 'rails_helper'
require 'support/shared_examples_for_views'

RSpec.describe 'sellers/edit' do
  let(:seller) { create(:seller) }

  before do
    assign(:seller, seller)
    render
  end

  it_behaves_like 'a standard view'

  it 'renders the seller edit form' do
    expect(view).to render_template partial: 'sellers/_form'
  end

  it 'links to seller home page' do
    assert_select(+'a[href=?]', seller_path)
  end

  context 'when seller has disabled emails' do
    let(:seller) { create(:seller, mailing: false) }

    it 'links to enable mailing' do
      assert_select(+'a[href=?][data-method=post]', mailing_seller_path)
    end
  end

  context 'when seller has enabled emails' do
    let(:seller) { create(:seller, mailing: true) }

    it 'links to disable mailing' do
      assert_select(+'a[href=?][data-method=delete]', mailing_seller_path)
    end
  end
end
