# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'admin/categories/index' do
  let(:category_with_item_limit) { create :category, max_items_per_seller: 4 }
  let(:category_with_size_fixed) { create :category_with_size_fixed }
  let(:categories) { [category_with_item_limit, category_with_size_fixed] }

  before { assign :categories, categories.paginate }

  it_behaves_like 'a standard view'

  it 'shows max items per seller column' do
    render
    expect(rendered).to have_content 'max. Anzahl'
    expect(rendered).to have_content '4'
  end

  it 'shows column with size option and edit link' do
    render
    expect(rendered).to have_content 'Größenangaben'
    expect(rendered).to have_content 'optional'
    expect(rendered).to have_content 'feste Werte'
    expect(rendered).to have_link href: admin_category_sizes_path(category_with_size_fixed)
  end

  it 'shows parent category' do
    render
    expect(rendered).to have_content 'Überkategorie'
  end

  describe 'donation column' do
    context 'when donation option is disabled' do
      before { Client.first.update donation_of_unsold_items: false }

      it 'does not show column' do
        render
        expect(rendered).not_to have_content 'Spendenzwang'
      end
    end

    context 'when donation option is enabled' do
      before { Client.first.update donation_of_unsold_items: true }

      it 'shows donation column' do
        render
        expect(rendered).to have_content 'Spendenzwang'
      end
    end
  end
end
