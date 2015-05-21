require 'rails_helper'

RSpec.feature 'admin home page' do
  def create_sellers
    FactoryGirl.create :seller
    FactoryGirl.create :seller, active: true
    FactoryGirl.create :notification
  end

  def create_items
    FactoryGirl.create :item
    FactoryGirl.create :label
    reservation = FactoryGirl.create :reservation
    FactoryGirl.create :item, seller: reservation.seller
  end

  def create_reviews
    FactoryGirl.create_list :review, 2
  end

  background do
    create_sellers
    create_items
    create_reviews
    visit admin_path
  end

  scenario 'shows summary of sellers' do
    expect(page).to have_content 'gesamt: 9'
    expect(page).to have_content 'aktiviert: 1'
    expect(page).to have_content 'wartend: 1'
  end

  scenario 'shows summary of items' do
    expect(page).to have_content 'gesamt: 3'
    expect(page).to have_content 'von Reservierungen: 1'
    expect(page).to have_content 'Etiketten: 1'
  end

  scenario 'shows summary of reviews' do
    expect(page).to have_content 'Bewertungen gesamt: 2'
  end

  scenario 'shows graph of items per category'
  scenario 'shows graph of items created per day'
  scenario 'shows graph of sellers created per day'
  scenario 'shows admin menu' do
    expect(page).to have_link 'Adminbereich'
    expect(page).to have_link 'Termine'
    expect(page).to have_link 'Kategorien'
    expect(page).to have_link 'Mails'
    expect(page).to have_link 'Passwort'
  end
  scenario 'asks for user credentials'
end
