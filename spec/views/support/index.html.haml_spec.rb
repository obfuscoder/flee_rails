# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'support/index' do
  let(:event) { create :event_with_support }
  let(:support_type) { event.support_types.first }
  let(:seller) { create :seller }
  let(:preparations) {}

  before do
    preparations
    assign :event, event
    assign :support_types, event.support_types
    assign :seller, seller
  end

  it_behaves_like 'a standard view'

  describe 'rendered' do
    subject { rendered }

    before { render }

    it { is_expected.to have_link href: seller_path }

    it { is_expected.to have_link href: event_new_support_path(event, support_type) }
    it { is_expected.not_to have_link href: event_destroy_support_path(event, support_type) }

    context 'with event support full' do
      let(:event) { create :event_with_support_full }

      it { is_expected.not_to have_link href: event_new_support_path(event, support_type) }
      it { is_expected.not_to have_link href: event_destroy_support_path(event, support_type) }
    end

    context 'with seller already supporting the event' do
      let(:preparations) { create :supporter, seller: seller, support_type: support_type }

      it { is_expected.not_to have_link href: event_new_support_path(event, support_type) }
      it { is_expected.to have_link href: event_destroy_support_path(event, support_type) }
    end
  end
end
