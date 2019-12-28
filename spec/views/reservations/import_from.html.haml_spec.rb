require 'rails_helper'

RSpec.describe 'reservations/import_from' do
  subject { rendered }

  let(:seller) { create :seller }
  let(:event) { create :event_with_ongoing_reservation }
  let(:reservation) { create :reservation, event: event, seller: seller }
  let(:previous_reservation) do
    Timecop.freeze 1.year.ago do
      create :reservation, seller: seller
    end
  end
  let(:items) { create_list :item, 5, reservation: previous_reservation }

  before do
    assign :event, event
    assign :reservation, reservation
    assign :from_reservation, previous_reservation
    assign :items, items.map { |item| [item.id, item.to_s] }
    render
  end

  it_behaves_like 'a standard view'

  it { is_expected.to have_link href: event_reservation_items_path(event, reservation) }
  it { is_expected.to have_field 'import[item][]' }
end
