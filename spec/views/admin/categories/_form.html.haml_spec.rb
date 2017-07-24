# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'admin/categories/_form' do
  let!(:parents) { create_list :category, 3 }
  before { assign :category, build(:category, max_items_per_seller: 4) }
  it_behaves_like 'a standard partial'

  it 'shows max items per seller input field' do
    render
    expect(rendered).to have_field 'max. Anzahl', with: '4'
  end

  it 'shows parent category selection' do
    render
    expect(rendered).to have_select('Überkategorie', with_options: parents.map(&:name))
  end
end
