require 'rails_helper'
require 'features/admin/login'

RSpec.describe 'admin login' do
  context 'when using correct credentials' do
    include_context 'when logging in'

    it 'shows admin homepage' do
      expect(page).to have_current_path(admin_path)
    end

    it 'can logout again' do
      click_on 'Abmelden'
      expect(page).to have_content 'Erfolgreich abgemeldet'
      expect(page).to have_current_path(root_path)
      expect(page).not_to have_content 'Abmelden'
    end

    describe 'change password' do
      let(:old_password) { 'password' }
      let(:new_password) { 'N3wP4ssword' }
      let(:password_repeat) { new_password }

      before do
        click_on 'Passwort ändern'
        fill_in 'user_old_password', with: old_password
        fill_in 'user_password', with: new_password
        fill_in 'user_password_confirmation', with: password_repeat
        click_on 'Änderungen speichern'
      end

      it 'can change password' do
        expect(page).to have_content 'Passwort wurde geändert'
      end

      context 'when not repeating the password' do
        let(:password_repeat) { 'differentpassword' }

        it 'can not change password' do
          expect(page).to have_content 'stimmt nicht überein'
        end
      end

      context 'when not providing old password' do
        let(:old_password) { '' }

        it 'can not change password' do
          expect(page).to have_content 'muss ausgefüllt werden'
        end
      end

      context 'when providing incorrect old password' do
        let(:old_password) { 'wrongpassword' }

        it 'can not change password' do
          expect(page).to have_content 'nicht korrekt'
        end
      end

      context 'when using old password as new password' do
        let(:new_password) { old_password }

        it 'can not change password' do
          expect(page).to have_content 'muss sich vom aktuellen Passwort unterscheiden'
        end
      end

      context 'when using weak password' do
        let(:new_password) { 'weakpassword' }

        it 'can not change password' do
          expect(page).to have_content 'muss mindestens 5 Zeichen lang sein und mindestens'
        end
      end
    end
  end

  context 'when using incorrect credentials' do
    include_context 'when logging in' do
      let(:password) { 'wrongpassword' }
    end

    it 'stays on login page' do
      expect(page).to have_current_path(admin_login_path)
    end

    it 'shows login error' do
      expect(page).to have_content 'Anmeldung fehlgeschlagen'
    end
  end
end
