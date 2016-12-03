require 'rails_helper'

RSpec.describe 'admin/categories/index' do
  let(:categories) { create_list :category, 5, max_items_per_seller: 4 }
  before { assign :categories, categories.paginate }

  it_behaves_like 'a standard view'

  it 'shows max items per seller column' do
    render
    expect(rendered).to have_content 'max. Anzahl'
    expect(rendered).to have_content '4'
  end

  it 'shows parent category' do
    render
    expect(rendered).to have_content 'Überkategorie'
  end

  describe 'donation column' do
    context 'when donation option is disabled' do
      before { allow(Settings.brands.demo).to receive(:donation_of_unsold_items_enabled) { false } }
      it 'does not show column' do
        render
        expect(rendered).not_to have_content 'Spendenzwang'
      end
    end

    context 'when donation option is enabled' do
      before { allow(Settings.brands.demo).to receive(:donation_of_unsold_items_enabled) { true } }
      it 'shows donation column' do
        render
        expect(rendered).to have_content 'Spendenzwang'
      end
    end
  end
end
