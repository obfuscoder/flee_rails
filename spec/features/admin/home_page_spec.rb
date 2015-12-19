require 'rails_helper'
require 'features/admin/login'

RSpec.feature 'admin home page' do
  def create_sellers
    create :seller, created_at: 1.day.ago
    create :seller, active: true, created_at: 7.days.ago
    create :notification
  end

  let!(:item) { create :item, created_at: 1.day.ago }
  let!(:item_with_code) { create :item_with_code }

  def create_reviews
    create_list :review, 2
  end

  background do
    create_sellers
    create_reviews
  end

  include_context 'login'

  scenario 'shows summary of sellers' do
    expect(page).to have_content 'gesamt: 7'
    expect(page).to have_content 'aktiviert: 1'
    expect(page).to have_content 'wartend: 1'
  end

  scenario 'shows summary of items' do
    expect(page).to have_content 'gesamt: 2'
    expect(page).to have_content 'Etiketten: 1'
  end

  scenario 'shows summary of reviews' do
    expect(page).to have_content 'Bewertungen gesamt: 2'
  end

  scenario 'shows graph of items per category' do
    expect(page).to have_content 'Artikel pro Kategorie'
    visit page.find('#canvas_items_per_category')['data-url']
    data = JSON.parse page.body
    expect(data.size).to eq 2
    expect(data[item.category.name]).to eq 1
    expect(data[item_with_code.category.name]).to eq 1
  end

  scenario 'shows graph of items created per day' do
    expect(page).to have_content 'Neue Artikel pro Tag'
    visit page.find('#canvas_items_per_day')['data-url']
    data = JSON.parse page.body
    expect(data.size).to eq 30
    expect(data[-2]).to eq [1.day.ago.strftime('%Y-%m-%d'), 1]
    expect(data.last).to eq [Time.now.strftime('%Y-%m-%d'), 1]
  end

  scenario 'shows graph of sellers created per day' do
    expect(page).to have_content 'Registrierungen pro Tag'
    visit page.find('#canvas_sellers_per_day')['data-url']
    data = JSON.parse page.body
    expect(data.size).to eq 30
    expect(data[-2]).to eq [1.day.ago.strftime('%Y-%m-%d'), 1]
    expect(data.last).to eq [Time.now.strftime('%Y-%m-%d'), 5]
  end

  scenario 'shows admin menu' do
    expect(page).to have_link 'Adminbereich'
    expect(page).to have_link 'Termine'
    expect(page).to have_link 'Kategorien'
    expect(page).to have_link 'Mails'
    expect(page).to have_link 'Passwort'
  end
end
