# frozen_string_literal: true

RSpec.shared_context 'login' do
  let(:admin) { create :admin }
  let(:password) { 'password' }

  before do
    visit 'http://demo.test.host/admin'
    fill_in 'eMail-Adresse', with: admin.email
    fill_in 'Passwort', with: password
    click_on 'Anmelden'
  end
end
