require 'rails_helper'

RSpec.feature 'admin categories' do
  let!(:categories) { FactoryGirl.create_list :category, 3 }
  let(:category) { categories.first }
  background do
    visit admin_path
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
    click_on 'Kategorie erstellen'
    expect(page).to have_content 'Die Kategorie wurde erfolgreich hinzugefügt.'
  end

  scenario 'delete category' do
    find("a[href='#{admin_category_path(category)}']", text: 'Löschen').click
    expect(page).to have_content 'Kategorie gelöscht.'
  end

  scenario 'edit category' do
    find("a[href='#{edit_admin_category_path(category)}']", text: 'Bearbeiten').click
    new_name = 'Kleinkram'
    fill_in 'Name', with: new_name
    click_on 'Kategorie aktualisieren'
    expect(page).to have_content 'Die Kategorie wurde erfolgreich aktualisiert.'
    expect(page).to have_content new_name
  end
end
