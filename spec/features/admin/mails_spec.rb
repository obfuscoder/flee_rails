require 'rails_helper'

RSpec.feature 'admin emails' do
  let!(:sellers) { FactoryGirl.create_list :seller, 10 }
  let(:selection) {}
  background do
    selection
    visit admin_path
    click_on 'Mails'
  end

  context 'with active sellers' do
    let(:selection) { sellers.take(2).each { |seller| seller.update active: true } }
    before do
      fill_in 'Betreff', with: 'Betreffzeile'
      fill_in 'Inhalt', with: 'Mailbody ' * 100
    end

    scenario 'select and send mail to several sellers' do
      within '#email_sellers' do
        selection.each do |seller|
          find("option[value='#{seller.id}']").select_option
        end
      end
      click_on 'Senden'
      expect(page).to have_content '2 Mails wurden versendet.'
    end
  end
end
