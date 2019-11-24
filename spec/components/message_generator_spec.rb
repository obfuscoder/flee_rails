# frozen_string_literal: true

require 'rails_helper'

RSpec.describe MessageGenerator do
  include ActionView::Helpers
  subject(:action) { described_class.new(data).generate template_message }

  let(:data) { { event: event, seller: seller, reservation: reservation, urls: urls } }
  let(:urls) { { login: '/login', reserve: '/reserve', review: '/review', results: '/results' } }
  let(:seller) { create :seller }
  let(:event) { create :event_with_ongoing_reservation }
  let(:reservation) { create :reservation, event: event, seller: seller }
  let(:template_message) { double subject: 'testsubject {{ event_name }}', body: t('hints.messages') }

  its(:subject) { is_expected.to eq "testsubject #{event.name}" }

  describe 'result body' do
    subject(:body) { action.body.gsub('{{ platzhalter }}', '') }

    it { is_expected.not_to include '{{' }
  end
end
