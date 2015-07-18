require 'rails_helper'
require 'features/admin/login'

RSpec.feature 'admin categories' do
  include_context 'login'
  let!(:categories) { FactoryGirl.create_list :category, 3 }
  let(:category) { categories.first }

  background do
    click_on 'Kategorien'
  end

  scenario 'shows list of categories with buttons for show, edit and delete' do
    categories.each do |category|
      expect(page).to have_content category.name
      expect(page).to have_link 'Bearbeiten', href: edit_admin_category_path(category)
      expect(page).to have_link 'Löschen', href: admin_category_path(category)
    end
  end

  scenario 'new category' do
    click_on 'Neue Kategorie'
    fill_in 'Name', with: 'Hosenkleid'
    expect(page).not_to have_field 'Spendenzwang'
    click_on 'Kategorie erstellen'
    expect(page).to have_content 'Die Kategorie wurde erfolgreich hinzugefügt.'
  end

  context 'when donation option is enabled' do
    before { allow(Settings.brands.default).to receive(:donation_of_unsold_items_enabled) { true } }
    scenario 'new category allows enabling donation enforcement and is shown in overview' do
      click_on 'Neue Kategorie'
      fill_in 'Name', with: 'Hosenkleid'
      check 'Spendenzwang'
      click_on 'Kategorie erstellen'
      expect(page).to have_content 'Spendenzwang'
      expect(page).to have_content 'ja'
    end
  end

  scenario 'delete category' do
    click_link nil, href: admin_category_path(category)
    expect(page).to have_content 'Kategorie gelöscht.'
  end

  scenario 'edit category' do
    click_link nil, href: edit_admin_category_path(category)
    new_name = 'Kleinkram'
    fill_in 'Name', with: new_name
    click_on 'Kategorie aktualisieren'
    expect(page).to have_content 'Die Kategorie wurde erfolgreich aktualisiert.'
    expect(page).to have_content new_name
  end
end
