# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'admin/suspensions/new' do
  let(:sellers) { create_list :seller, 3 }

  before do
    assign :event, create(:event)
    assign :sellers, sellers
  end

  it_behaves_like 'a standard view'

  describe 'rendered' do
    subject { rendered }

    before { render }

    it { is_expected.to have_content sellers.first.label_for_selects }

    it { is_expected.to have_field 'Grund' }
  end
end
