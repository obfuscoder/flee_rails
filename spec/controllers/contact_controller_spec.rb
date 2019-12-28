require 'rails_helper'

RSpec.describe ContactController do
  let(:preparation) {}

  describe 'GET show' do
    before do
      preparation
      get :show
    end

    it { expect(response).to render_template :show }
    it { expect(response).to have_http_status :ok }

    context 'when seller is logged in' do
      let(:seller) { create :seller }
      let(:preparation) { session[:seller_id] = seller.id }

      it { expect(response).to render_template :show }
      it { expect(response).to have_http_status :ok }

      describe '@seller' do
        subject { assigns :seller }

        it { is_expected.to eq seller }
      end
    end
  end

  describe 'POST submit' do
    before do
      preparation
      allow(NotificationMailer).to receive(:contact).and_return notification_mailer
      post :submit, params: { contact: contact_params }
    end

    let(:notification_mailer) { double deliver_now: nil }
    let(:email) { Faker::Internet.email }
    let(:name) { Faker::Name.name }
    let(:contact) { build :contact }
    let(:contact_params) { { email: email, name: name, topic: contact.topic, body: contact.body } }

    it { expect(response).to redirect_to contact_submitted_path }

    it 'sends email' do
      expect(NotificationMailer).to have_received(:contact).with(hash_including(email: email,
                                                                                name: name,
                                                                                subject: contact.topic,
                                                                                body: contact.body))
      expect(notification_mailer).to have_received(:deliver_now)
    end

    context 'with invalid input' do
      let(:contact_params) { { email: 'asdadsa', name: '', topic: '', body: '' } }

      it { expect(response).to render_template :show }
      it { expect(response).to have_http_status :ok }
    end

    context 'when seller is logged in' do
      let(:seller) { create :seller }
      let(:preparation) { session[:seller_id] = seller.id }
      let(:contact_params) { { topic: contact.topic, body: contact.body } }

      it { expect(response).to redirect_to contact_submitted_path }

      it 'sends email' do
        expect(NotificationMailer).to have_received(:contact).with(hash_including(client: seller.client,
                                                                                  email: seller.email,
                                                                                  name: seller.name,
                                                                                  subject: contact.topic,
                                                                                  body: contact.body))
        expect(notification_mailer).to have_received(:deliver_now)
      end
    end
  end

  describe 'GET submitted' do
    before { get :submitted }

    it { expect(response).to render_template :submitted }
    it { expect(response).to have_http_status :ok }
  end
end
