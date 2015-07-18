require 'rails_helper'

RSpec.describe 'admin/categories/index' do
  let(:categories) { FactoryGirl.create_list :category, 5 }
  before { assign :categories, categories.paginate }

  it_behaves_like 'a standard view'

  it 'does not show donation column' do
    render
    expect(rendered).not_to have_content 'Spendenzwang'
  end

  context 'when donation option is enabled' do
    before { allow(Settings.brands.default).to receive(:donation_of_unsold_items_enabled) { true } }
    it 'shows donation column' do
      render
      expect(rendered).to have_content 'Spendenzwang'
    end
  end
end
