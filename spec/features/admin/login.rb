RSpec.shared_context 'when logging in' do
  let(:admin) { create :admin }
  let(:password) { 'password' }

  before do
    visit 'http://demo.test.host/admin'
    fill_in 'eMail-Adresse', with: admin.email
    fill_in 'Passwort', with: password
    click_on 'Anmelden'
  end
end
