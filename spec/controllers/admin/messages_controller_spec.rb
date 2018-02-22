# frozen_string_literal: true

require 'rails_helper'

module Admin
  RSpec.describe MessagesController do
    include Sorcery::TestHelpers::Rails::Controller
    before { login_user create(:user) }
    let(:event) { create :event }
    let!(:seller) { create :seller }

    describe 'POST :invitation' do
      let(:action) { post :invitation, event_id: event.id }
      let(:reservable) { true }
      before do
        allow(SellerMailer).to receive(:invitation).and_return(double(deliver_later: nil))
        allow_any_instance_of(Event).to receive(:reservable_by?).with(seller).and_return(reservable)
        action
      end
      subject { response }

      it { is_expected.to redirect_to admin_event_path(event) }

      it 'sends mails' do
        expect(SellerMailer).to have_received(:invitation).with(seller, event)
      end

      context 'when not reservable by seller' do
        let(:reservable) { false }
        it 'does not send mail to this seller' do
          expect(SellerMailer).not_to have_received(:invitation).with(seller, event)
        end
      end
    end
  end
end
