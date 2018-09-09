# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'admin/rentals/index' do
  let(:rental) { create :rental }
  let(:event) { rental.event }

  before do
    assign :rentals, [rental]
    assign :event, event
  end

  it_behaves_like 'a standard view'

  describe 'rendered' do
    subject { rendered }

    before { render }

    it { is_expected.to have_content rental.amount }
    it { is_expected.to have_content rental.hardware.description }
    it { is_expected.to have_link 'Löschen', href: admin_event_rental_path(event, rental) }
    it { is_expected.to have_link 'Neue Leihe', href: new_admin_event_rental_path(event) }
    it { is_expected.to have_link 'Bearbeiten', href: edit_admin_event_rental_path(event, rental) }
  end
end
