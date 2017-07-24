# frozen_string_literal: true

require 'rails_helper'
require 'features/admin/login'

RSpec.feature 'admin event reviews' do
  include_context 'login'
  let!(:event) { create :event_with_ongoing_reservation }
  let!(:reviews) do
    %i[good_review bad_review incomplete_review].map do |review|
      reservation = create :reservation, event: event
      create review, reservation: reservation
    end
  end
  background do
    click_on 'Termine'
    click_on 'Anzeigen'
    click_on 'Bewertungen'
  end

  scenario 'shows review summary' do
    expect(page).to have_content 'Bewertungen'
    expect(page).to have_content 'Anzahl: 3'
    reviews.each do |review|
      expect(page).to have_link review.reservation.number, href: admin_seller_path(review.reservation.seller)
    end
    expect(page).to have_content '2,0'
    expect(page).to have_content '2,3'
    expect(page).to have_content '1x nein (33%)'
    expect(page).to have_content '1x ja (33%)'
    expect(page).to have_content '1x keine Angabe (33%)'
    expect(page).to have_content '1x Internet (33%)'
    expect(page).to have_content '1x Bekannte/Familie (33%)'
    reviews.select(&:to_improve).each do |review|
      expect(page).to have_content review.to_improve
      expect(page).to have_content review.reservation.seller.to_s
    end
  end
end
