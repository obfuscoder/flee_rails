# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'Brand switching' do
  scenario 'Demo brand' do
    visit '/'
    expect(page).to have_content 'Flohmarkthelfer Demo'
  end

  scenario 'Koenigsbach brand' do
    visit 'http://flohmarkt-koenigsbach.de/'
    expect(page).to have_content 'Flohmarkt Königsbach'
    visit 'http://www.flohmarkt-koenigsbach.de/'
    expect(page).to have_content 'Flohmarkt Königsbach'
    visit '/'
    expect(page).to have_content 'Flohmarkthelfer'
  end
end
