# frozen_string_literal: true

require 'rails_helper'
require 'features/admin/login'

RSpec.feature 'admin emails' do
  include_context 'login'

  let!(:sellers) { create_list :seller, 10 }
  let(:selection){}

  background do
    selection
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
      within '#custom_email_sellers' do
        selection.each do |seller|
          find("option[value='#{seller.id}']").select_option
        end
      end
      click_on 'Senden'
      expect(page).to have_content '2 Mails wurden versendet.'

      selection.each do |seller|
        open_email seller.email
        expect(current_email.subject).to eq subject
        expect(current_email.body).to include body
      end
    end
  end
end
