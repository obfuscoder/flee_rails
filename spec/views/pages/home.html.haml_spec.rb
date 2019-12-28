require 'rails_helper'

RSpec.describe 'pages/home.html.haml' do
  subject { rendered }

  let(:event) { create :event, confirmed: false }
  let(:events) { [event] }

  before do
    assign :events, events
    render
  end

  it 'does not set content for title' do
    expect(view.content_for(:title)).to be_nil
  end

  it { is_expected.to have_link href: new_seller_path }
  it { is_expected.to have_link href: resend_activation_seller_path }

  describe 'event listing' do
    it { is_expected.to have_content event.name }

    context 'when event is not confirmed' do
      it { is_expected.not_to have_text 'Reservierungsstart' }
    end

    context 'when event is confirmed' do
      let(:event) { create :event, confirmed: true }

      it { is_expected.to have_text 'Reservierungsstart', count: 1 }
      it { is_expected.to have_text 'Artikelabgabe', count: 1 }
      it { is_expected.to have_text "#{event.reservations_left} von #{event.max_reservations}" }

      context 'when event kind is direct' do
        let(:event) { create :event, confirmed: true, kind: :direct }

        it { is_expected.not_to have_text 'Artikelabgabe' }
      end
    end
  end

  context 'without events' do
    let(:events) { [] }

    it { is_expected.to match(/Aktuell sind keine/) }
  end
end
