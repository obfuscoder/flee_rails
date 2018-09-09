# frozen_string_literal: true

require 'rails_helper'
require 'features/admin/login'
require 'features/mail_support'

RSpec.describe 'admin emails' do
  include_context 'when logging in'

  let!(:sellers) { create_list :seller, 10, active: false }
  let(:selection) {}

  before do
    selection
    click_on 'Mails'
  end

  context 'with active sellers' do
    let(:selection) { sellers.take(2).each { |seller| seller.update active: true } }
    let(:mail_subject) { 'Mailsubject' }
    let(:body) { 'Mailbody ' * 100 }

    before do
      fill_in 'Betreff', with: mail_subject
      fill_in 'Inhalt', with: body
    end

    it 'select and send mail to several sellers' do
      within '#custom_email_sellers' do
        selection.each do |seller|
          find("option[value='#{seller.id}']").select_option
        end
      end
      click_on 'Senden'
      expect(page).to have_content 'Es werden 2 Mails verschickt.'

      selection.each do |seller|
        send_and_open_email seller.email
        expect(current_email.subject).to eq mail_subject
        expect(current_email.body).to include body
      end
    end
  end
end
