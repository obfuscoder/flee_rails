RSpec.shared_context 'login' do
  let(:admin) { FactoryGirl.create :admin }
  let(:password) { 'password' }

  before do
    visit admin_path
    fill_in 'eMail-Adresse', with: admin.email
    fill_in 'Passwort', with: password
    click_on 'Anmelden'
  end
end
