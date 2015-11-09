require 'rails_helper'

RSpec.describe 'pages/home.html.haml' do
  let(:event) { create :event, confirmed: false }
  let(:events) { [event] }
  before do
    assign :events, events
    render
  end

  it 'does not set content for title' do
    expect(view.content_for(:title)).to be_nil
  end

  it 'links to registration' do
    assert_select 'a[href=?]', new_seller_path
  end

  it 'links to seller resend activation' do
    assert_select 'a[href=?]', resend_activation_seller_path
  end

  describe 'event listing' do
    it 'lists the events' do
      assert_select 'ul>li>h4', event.name
    end

    context 'when event is not confirmed' do
      it 'does not show reservation start' do
        expect(rendered).not_to have_text 'Reservierungsstart', count: 1
      end
    end

    context 'when event is confirmed' do
      let(:event) { create :event, confirmed: true }
      it 'does show reservation start' do
        expect(rendered).to have_text 'Reservierungsstart', count: 1
      end

      it 'does show handover time' do
        expect(rendered).to have_text 'Artikelabgabe', count: 1
      end

      context 'when event kind is direct' do
        let(:event) { create :event, confirmed: true, kind: :direct }
        it 'does not show handover time' do
          expect(rendered).not_to have_text 'Artikelabgabe', count: 1
        end
      end
    end
  end

  context 'without events' do
    let(:events) { [] }
    it 'it displays info that there are no events' do
      expect(rendered).to match(/Aktuell sind keine/)
    end
  end
end
