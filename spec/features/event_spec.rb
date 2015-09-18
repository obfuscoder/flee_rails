require 'rails_helper'

RSpec.feature 'Event results' do
  let!(:seller) { FactoryGirl.create :seller }
  let!(:event) { FactoryGirl.create :event }

  def visit_results_link
    visit login_seller_url(seller.token, goto: :show, event: event)
  end

  def login_and_navigate_to_event_results
    visit login_seller_url(seller.token)
    click_on 'Ergebnisse'
  end

  def login_and_open_event_results_directly
    visit login_seller_url(seller.token)
    visit event_path(event)
  end

  shared_examples 'a forbidden action' do
    [:visit_results_link, :login_and_open_event_results_directly].each do |action|
      context "when using action #{action}" do
        before { send(action) }
        it 'shows seller home page' do
          expect(current_path).to eq seller_path
        end

        it 'shows error message that results are not available' do
          expect(page).to have_content 'Ergebnisse des Flohmarkts nicht verfügbar'
        end
      end
    end

    it 'does not show link to results' do
      visit login_seller_url(seller.token)
      expect(page).not_to have_link 'Ergebnisse'
    end
  end

  shared_examples 'an allowed action' do
    [:visit_results_link, :login_and_navigate_to_event_results, :login_and_open_event_results_directly].each do |action|
      context "when using action #{action}" do
        before { send(action) }
        it 'shows results page' do
          skip if action == :login_and_navigate_to_event_results
          expect(current_path).to eq event_path(event)
        end
      end
    end
  end

  context 'without reservation' do
    context 'when event has passed' do
      before { Timecop.travel event.shopping_periods.first.max + 1.hour }
      after { Timecop.return }

      it_behaves_like 'a forbidden action'
    end

    context 'when event is ongoing' do
      before { Timecop.travel event.shopping_periods.first.max - 1.hour }
      after { Timecop.return }

      it_behaves_like 'a forbidden action'
    end
  end

  context 'with reservation' do
    before do
      event.reservation_start = 1.hour.ago
      FactoryGirl.create :reservation, event: event, seller: seller
    end
    context 'when event has passed' do
      before { Timecop.travel event.shopping_periods.first.max + 1.hour }
      after { Timecop.return }

      # SKIPPED until event review results is implemented
      # it_behaves_like 'an allowed action'

      scenario 'show event results' do
        skip 'disabled until results are implemented'
        login_and_navigate_to_event_results
        expect(page).to have_content 'Ergebnisse'
      end
    end

    context 'when event is ongoing' do
      before { Timecop.travel event.shopping_periods.first.max - 1.hour }
      after { Timecop.return }

      it_behaves_like 'a forbidden action'
    end
  end
end
