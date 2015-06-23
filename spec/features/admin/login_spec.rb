require 'rails_helper'
require 'features/admin/login'

RSpec.feature 'admin login' do
  context 'when using correct credentials' do
    include_context 'login'

    it 'shows admin homepage' do
      expect(current_path).to eq admin_path
    end

    xit 'can logout again' do
      click_on 'Abmelden'
      expect(page).to have_content 'Erfolgreich abgemeldet'
      expect(current_path).to eq home_path
    end
  end

  context 'when using incorrect credentials' do
    include_context 'login' do
      let(:password) { 'wrongpassword' }
    end

    it 'stays on login page' do
      expect(current_path).to eq admin_login_path
    end

    it 'shows login error' do
      expect(page).to have_content 'Anmeldung fehlgeschlagen'
    end
  end
end
