require 'rails_helper'

RSpec.describe 'admin/categories/_form' do
  let!(:parents) { create_list :category, 3 }
  let(:category) { build :category, max_items_per_seller: 4 }

  before { assign :category, category }

  it_behaves_like 'a standard partial'

  describe 'rendered' do
    subject { rendered }

    before { render }

    it { is_expected.to have_field 'max. Anzahl', with: '4' }
    it { is_expected.to have_select('Überkategorie', with_options: parents.map(&:name)) }

    Category.size_options.keys.each do |option|
      it { is_expected.to have_field('category_size_option_' + option) }
    end
    it { is_expected.to have_checked_field('category_size_option_optional') }

    context 'with category with disabled size option' do
      let(:category) { build :category_with_size_disabled }

      it { is_expected.to have_checked_field('category_size_option_disabled') }
    end

    it { is_expected.to have_field('category_gender') }
  end
end
