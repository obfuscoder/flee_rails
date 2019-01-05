# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'contact/show' do
  let(:contact) { build :contact }

  before { assign :contact, contact }

  it_behaves_like 'a standard view'

  describe 'rendered' do
    subject { rendered }

    let(:preparation) {}

    before do
      preparation
      render
    end

    it { is_expected.to have_field 'contact_name' }
    it { is_expected.to have_field 'contact_email' }
    it { is_expected.to have_field 'contact_topic' }
    it { is_expected.to have_field 'contact_body' }

    context 'when seller is assigned' do
      let(:seller) { create(:seller) }
      let(:preparation) { assign :seller, seller }

      it { is_expected.not_to have_field 'contact_email' }
      it { is_expected.not_to have_field 'contact_name' }
      it { is_expected.to have_content seller.email }
    end
  end
end
