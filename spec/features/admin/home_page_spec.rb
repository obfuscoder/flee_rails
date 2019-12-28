require 'rails_helper'
require 'features/admin/login'

RSpec.describe 'admin home page' do
  def create_sellers
    create :seller, active: false, created_at: 1.day.ago
    create :seller, created_at: 7.days.ago
    create :notification
  end

  let!(:item) { create :item, created_at: 1.day.ago }
  let!(:item_with_code) { create :item_with_code }

  def create_reviews
    create_list :review, 2
  end

  before do
    create_sellers
    create_reviews
  end

  include_context 'when logging in'

  it 'shows summary of sellers' do
    expect(page).to have_content 'gesamt: 7'
    expect(page).to have_content 'aktiviert: 6'
  end

  it 'shows summary of items' do
    expect(page).to have_content 'gesamt: 2'
    expect(page).to have_content 'Etiketten: 1'
  end

  it 'shows summary of reviews' do
    expect(page).to have_content "Bewertungen\ngesamt: 2"
  end

  it 'shows graph of items per category' do
    expect(page).to have_content 'Artikel pro Kategorie'
  end

  it 'shows graph of items created per day' do
    expect(page).to have_content 'Neue Artikel pro Tag'
  end

  it 'shows graph of sellers created per day' do
    expect(page).to have_content 'Registrierungen pro Tag'
  end

  it 'shows admin menu' do
    expect(page).to have_link 'Adminbereich'
    expect(page).to have_link 'Termine'
    expect(page).to have_link 'Kategorien'
    expect(page).to have_link 'Mails'
    expect(page).to have_link 'Passwort'
  end
end
