require 'rails_helper'
require_relative 'shared_examples_for_mailers'

RSpec.describe NotificationMailer do
  let(:client) { Client.first }
  let(:to) { client.mail_address }

  describe '#supporter_created' do
    subject(:mail) { described_class.supporter_created supporter }

    let(:supporter) { build :supporter }
    let(:expected_contents) do
      [
        supporter.seller.first_name, supporter.seller.last_name, supporter.seller.email,
        supporter.comments,
        supporter.support_type.name,
        supporter.support_type.event.name
      ]
    end

    it_behaves_like 'a mail'

    its(:subject) { is_expected.to include 'Neuer Helfer' }
  end

  describe '#supporter_destroyed' do
    subject(:mail) { described_class.supporter_destroyed support_type, seller }

    let(:support_type) { build :support_type }
    let(:seller) { build :seller }
    let(:expected_contents) do
      [
        seller.first_name, seller.last_name, seller.email,
        support_type.name,
        support_type.event.name
      ]
    end

    it_behaves_like 'a mail'

    its(:subject) { is_expected.to include 'Helfer zurückgetreten' }
  end

  describe '#contact' do
    subject(:mail) { described_class.contact contact.to_options.merge(client: client) }

    let(:contact) { build :contact }
    let(:expected_contents) { [contact.email, contact.name, contact.topic] }

    it_behaves_like 'a mail'

    its(:subject) { is_expected.to include 'Kontaktanfrage' }
  end

  describe '#label_document_created' do
    subject(:mail) { described_class.label_document_created event, download_url }

    let(:event) { build :event }
    let(:download_url) { 'download_url' }
    let(:expected_contents) { [download_url] }

    it_behaves_like 'a mail'

    its(:subject) { is_expected.to include 'Etiketten' }
  end

  describe '#reset_password_instructions' do
    subject(:mail) { described_class.reset_password_instructions user }

    let(:token) { 'reset_token' }
    let(:to) { user.email }
    let(:user) { create :user, reset_password_token: token }
    let(:expected_contents) { ["reset_password/token/#{token}"] }

    it_behaves_like 'a mail'
  end

  describe '#user_created' do
    subject(:mail) { described_class.user_created user, password }

    let(:user) { create :user }
    let(:to) { user.email }
    let(:password) { 'Admin123' }
    let(:expected_contents) { [user.email, password, admin_path] }

    it_behaves_like 'a mail'
  end
end
