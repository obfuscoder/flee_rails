require 'rails_helper'

RSpec.feature 'admin events' do
  let(:events) { FactoryGirl.create_list :event, 3 }
  background do
    events
    visit admin_path
    click_on 'Termine'
  end

  scenario 'shows list of events with buttons for show, edit and delete' do
    events.each do |event|
      expect(page).to have_content event.name
      expect(page).to have_content event.shopping_start
      expect(page).to have_content event.reservation_start
      expect(page).to have_link 'Anzeigen', href: admin_event_path(event)
      expect(page).to have_link 'Bearbeiten', href: edit_admin_event_path(event)
      expect(page).to have_link 'Löschen', href: admin_event_path(event)
    end
  end
end
