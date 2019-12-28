require 'rails_helper'

RSpec.describe 'mail request' do
  let(:mail_content) { File.binread(File.dirname(__FILE__) + '/registration_mail.txt') }
  let(:preparations) {}

  before do
    preparations
    post '/mail', params: mail_content, headers: { content_type: 'application/octet-stream' }
  end

  describe 'response' do
    subject { response }

    context 'when sender is unknown' do
      it { is_expected.to have_http_status :no_content }
    end

    context 'when sender is known' do
      let(:seller) { create :seller, email: 'erika.mustermann@flohmarkthelfer.de' }
      let(:preparations) { seller }

      it { is_expected.to have_http_status :no_content }

      describe 'received and stored mail' do
        subject { seller.reload.emails.first }

        it do
          is_expected.to have_attributes from: seller.email,
                                         seller: seller,
                                         subject: 'RE: Registrierungsbestätigung',
                                         message_id: '5988ae06a99b4_406e25ae68040458@flohmarkthelfer.mail',
                                         to: 'demo@test.host',
                                         sent: false
        end

        its(:body) { is_expected.to include '[Zum geschützten Bereich]' }
      end
    end
  end
end
