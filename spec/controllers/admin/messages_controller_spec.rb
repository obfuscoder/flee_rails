# frozen_string_literal: true

require 'rails_helper'

module Admin
  RSpec.describe MessagesController do
    include Sorcery::TestHelpers::Rails::Controller
    before { login_user create(:user) }

    describe 'POST :invitation' do
      let(:event) { create :event }
      let(:action) { post :invitation, event_id: event.id }
      let(:count) { 3 }
      before do
        allow(SendInvitation).to receive(:new).and_return(double(call: count))
        action
      end
      subject { response }

      it { is_expected.to redirect_to admin_event_path(event) }

      it 'sends invitation' do
        expect(SendInvitation).to have_received(:new).with event
      end
    end
  end
end
