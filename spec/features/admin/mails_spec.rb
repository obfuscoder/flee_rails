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
    let(:subject) { 'Betreffzeile' }
    let(:body) { 'Mailbody ' * 100 }
    before do
      fill_in 'Betreff', with: subject
      fill_in 'Inhalt', with: body
    end

    scenario 'select and send mail to several sellers' do
      within '#email_sellers' do
        selection.each do |seller|
          find("option[value='#{seller.id}']").select_option
        end
      end
      click_on 'Senden'
      expect(page).to have_content '2 Mails wurden versendet.'

      selection.each do |seller|
        open_email seller.email
        expect(current_email.subject).to eq subject
        expect(current_email.body).to eq body
      end
    end
  end
end
