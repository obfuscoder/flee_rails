# frozen_string_literal: true

require 'rails_helper'

module Admin
  RSpec.describe MessagesController do
    include Sorcery::TestHelpers::Rails::Controller
    before { login_user create(:user) }

    describe 'POST :invitation' do
      subject(:action) { post :invitation, event_id: event.id }

      let(:event) { create :event }
      let(:count) { 3 }
      let(:sender) { double call: count }

      before do
        allow(SendInvitationMails).to receive(:new).and_return sender
        action
      end

      it 'sends invitation' do
        expect(SendInvitationMails).to have_received(:new).with event
        expect(sender).to have_received :call
      end

      describe 'response' do
        subject { response }

        it { is_expected.to redirect_to admin_event_path event }
      end

      describe 'flash[:notice]' do
        subject { flash[:notice] }

        it { is_expected.to include count.to_s }
      end
    end

    describe 'POST :reservation_closing' do
      subject(:action) { post :reservation_closing, event_id: event.id }

      let(:event) { create :event }
      let(:count) { 3 }
      let(:sender) { double call: count }

      before do
        allow(SendReservationClosingMails).to receive(:new).and_return sender
        action
      end

      it 'uses sender' do
        expect(SendReservationClosingMails).to have_received(:new).with event
        expect(sender).to have_received :call
      end

      describe 'response' do
        subject { response }

        it { is_expected.to redirect_to admin_event_path event }
      end

      describe 'flash[:notice]' do
        subject { flash[:notice] }

        it { is_expected.to include count.to_s }
      end
    end

    describe 'POST :reservation_closed' do
      subject(:action) { post :reservation_closed, event_id: event.id }

      let(:event) { create :event }
      let(:count) { 3 }
      let(:sender) { double call: count }

      before do
        allow(SendReservationClosedMails).to receive(:new).and_return sender
        action
      end

      it 'uses sender' do
        expect(SendReservationClosedMails).to have_received(:new).with event
        expect(sender).to have_received :call
      end

      describe 'response' do
        subject { response }

        it { is_expected.to redirect_to admin_event_path event }
      end

      describe 'flash[:notice]' do
        subject { flash[:notice] }

        it { is_expected.to include count.to_s }
      end
    end

    describe 'POST :finished' do
      subject(:action) { post :finished, event_id: event.id }

      let(:event) { create :event }
      let(:count) { 3 }
      let(:sender) { double call: count }

      before do
        allow(SendFinishedMails).to receive(:new).and_return sender
        action
      end

      it 'uses sender' do
        expect(SendFinishedMails).to have_received(:new).with event
        expect(sender).to have_received :call
      end

      describe 'response' do
        subject { response }

        it { is_expected.to redirect_to admin_event_path event }
      end

      describe 'flash[:notice]' do
        subject { flash[:notice] }

        it { is_expected.to include count.to_s }
      end
    end
  end
end
