require 'rails_helper'

RSpec.describe 'admin/stock_items/index' do
  let(:stock_item) { create :stock_item, price: 1.9 }

  before { assign :stock_items, [stock_item] }

  it_behaves_like 'a standard view'

  describe 'rendered' do
    subject(:output) { rendered }

    before { render }

    it 'renders price in Euro' do
      expect(output).to have_content '1,90 €'
    end

    it { is_expected.to have_link href: new_admin_stock_item_path }
    it { is_expected.to have_link href: edit_admin_stock_item_path(stock_item) }
    it { is_expected.to have_link href: print_admin_stock_items_path }
  end
end
