require 'rails_helper'

RSpec.describe 'admin/stock_items/new' do
  before { assign :stock_item, StockItem.new }

  before { render }

  it_behaves_like 'a standard view'

  it 'renders the edit form' do
    expect(view).to render_template partial: 'admin/stock_items/_form'
  end
end
