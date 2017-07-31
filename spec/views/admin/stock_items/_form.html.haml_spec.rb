# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'admin/stock_items/_form' do
  let(:stock_item) { build :stock_item }
  before { assign :stock_item, stock_item }

  it_behaves_like 'a standard partial'

  describe 'rendered' do
    before { render }
    subject { rendered }

    it { is_expected.to have_field 'Preis' }
    it { is_expected.to have_field 'Beschreibung' }

    context 'when stock item is persisted' do
      let(:stock_item) { create :stock_item }
      it { is_expected.not_to have_field 'Preis' }
    end
  end
end
