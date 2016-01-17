require 'rails_helper'

RSpec.describe 'admin/events/stats' do
  let(:event) { create :event_with_ongoing_reservation }
  let(:reservation) { create :reservation, event: event }
  let(:items) { create_list :item, 10, reservation: reservation }
  let!(:items_with_code) { items.take(8).each(&:create_code).each(&:save!) }
  let!(:sold_items) { items_with_code.take(6).each { |item| item.update! sold: Time.now } }
  before { assign :event, event }
  it_behaves_like 'a standard view'

  describe 'rendered' do
    before { render }
    subject { rendered }
    it { is_expected.to have_content items.count }
    it { is_expected.to have_content items_with_code.count }
    it { is_expected.to have_content sold_items.count }
  end
end
