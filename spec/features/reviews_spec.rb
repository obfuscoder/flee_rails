require 'rails_helper'

RSpec.feature 'Reviews' do
  let(:reservation) { create :reservation }
  let!(:seller) { reservation.seller }
  let!(:event) { reservation.event }

  def visit_review_link
    visit login_seller_url(seller.token, goto: :review, event: event)
  end

  def login_and_navigate_to_event_review
    visit login_seller_url(seller.token)
    click_on 'Flohmarkt bewerten'
  end

  def login_and_open_event_review_directly
    visit login_seller_url(seller.token)
    visit review_event_path(event)
  end

  shared_examples 'review is not allowed' do
    [:visit_review_link, :login_and_open_event_review_directly].each do |action|
      context "when using action #{action}" do
        before { send(action) }
        it 'shows seller home page' do
          expect(current_path).to eq seller_path
        end

        it 'shows error message that review is not possible' do
          expect(page).to have_content 'Bewertung des Flohmarkts nicht möglich'
        end
      end
    end

    it 'does not show link to review' do
      visit login_seller_url(seller.token)
      expect(page).not_to have_link 'Flohmarkt bewerten'
    end
  end

  shared_examples 'review is allowed' do
    [:visit_review_link, :login_and_navigate_to_event_review, :login_and_open_event_review_directly].each do |action|
      context "when using action #{action}" do
        before { send(action) }
        it 'shows new review page' do
          expect(current_path).to eq new_event_reservation_review_path(event, 1)
        end
      end
    end
  end

  context 'when event has passed' do
    before { Timecop.travel event.shopping_periods.first.max + 1.hour }
    after { Timecop.return }

    it_behaves_like 'review is allowed'

    scenario 'review event' do
      login_and_navigate_to_event_review
      expect(page).to have_content 'Bewertung'
      within('.review_registration') { choose '2' }
      within('.review_total') { choose '3' }
      choose 'Zeitungsanzeige'
      choose 'Ja'
      fill_in 'Welche Dinge haben Ihnen nicht gefallen bzw. was sollten wir Ihrer Meinung nach verbessern?',
              with: 'Mehr Farben'
      click_on 'Bewertung abschließen'
      expect(page).to have_content 'Vielen Dank für Ihre Bewertung'
    end

    context 'when review was done already' do
      before { create :review, reservation: reservation }

      it_behaves_like 'review is not allowed'
    end
  end

  context 'when event is ongoing' do
    before { Timecop.travel event.shopping_periods.first.max - 1.hour }
    after { Timecop.return }

    it_behaves_like 'review is not allowed'
  end
end
