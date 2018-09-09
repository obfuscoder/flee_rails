# frozen_string_literal: true

require 'rails_helper'
require_relative 'shared_examples_for_mailers'

RSpec.shared_examples 'a notification mail' do
  let(:to) { client.mail_address }

  it_behaves_like 'a mail'
end

RSpec.describe NotificationMailer do
  let(:client) { Client.first }

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

    it_behaves_like 'a notification mail'

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

    it_behaves_like 'a notification mail'

    its(:subject) { is_expected.to include 'Helfer zurückgetreten' }
  end
end
