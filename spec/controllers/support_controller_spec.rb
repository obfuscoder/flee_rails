# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SupportController do
  let(:seller) { create :seller }
  let!(:event) { create :event_with_support }

  before { session[:seller_id] = seller.id }

  describe 'GET index' do
    before { get :index, params: { event_id: event.id } }

    describe 'response' do
      subject { response }

      it { is_expected.to render_template :index }
      it { is_expected.to have_http_status :ok }
    end

    describe '@support_types' do
      subject { assigns :support_types }

      it { is_expected.to eq event.support_types }
    end

    describe '@seller' do
      subject { assigns :seller }

      it { is_expected.to eq seller }
    end

    describe '@event' do
      subject { assigns :event }

      it { is_expected.to eq event }
    end
  end

  describe 'GET new' do
    let(:support_type) { event.support_types.first }

    before { get :new, params: { event_id: event.id, id: support_type.id } }

    describe 'response' do
      subject { response }

      it { is_expected.to render_template :new }
      it { is_expected.to have_http_status :ok }
    end

    describe '@support_type' do
      subject { assigns :support_type }

      it { is_expected.to eq support_type }
    end

    describe '@supporter' do
      subject { assigns :supporter }

      it { is_expected.to be_a_new Supporter }
    end

    describe '@seller' do
      subject { assigns :seller }

      it { is_expected.to eq seller }
    end

    describe '@event' do
      subject { assigns :event }

      it { is_expected.to eq event }
    end
  end

  describe 'DELETE destroy' do
    let(:support_type) { event.support_types.first }
    let(:supporter) { create :supporter, support_type: support_type, seller: seller }
    let(:notification_mailer) { double deliver_later: nil }
    let(:preparations) {}

    before do
      preparations
      supporter
      allow(NotificationMailer).to receive(:supporter_destroyed).and_return notification_mailer
      delete :destroy, params: { event_id: event.id, id: support_type.id }
    end

    describe 'response' do
      subject { response }

      it { is_expected.to redirect_to event_support_path(event) }
    end

    describe 'flash' do
      subject { flash }

      its([:notice]) { is_expected.not_to be_nil }
      its([:alert]) { is_expected.to be_nil }
    end

    it 'destroys supporter' do
      expect { supporter.reload }.to raise_error ActiveRecord::RecordNotFound
    end

    it 'sends notification mail' do
      expect(NotificationMailer).to have_received(:supporter_destroyed).with(support_type, seller)
      expect(notification_mailer).to have_received(:deliver_later)
    end

    context 'when supporters cannot retire' do
      let(:preparations) { event.update! supporters_can_retire: false }

      it 'does not destroy supporter' do
        expect { supporter.reload }.not_to raise_error
      end

      it 'does not send notification mail' do
        expect(NotificationMailer).not_to have_received(:supporter_destroyed)
      end

      describe 'response' do
        subject { response }

        it { is_expected.to redirect_to event_support_path(event) }
      end

      describe 'flash' do
        subject { flash }

        its([:alert]) { is_expected.not_to be_nil }
        its([:notice]) { is_expected.to be_nil }
      end
    end
  end

  describe 'POST create' do
    let(:support_type) { event.support_types.first }
    let(:notification_mailer) { double deliver_later: nil }

    before do
      allow(NotificationMailer).to receive(:supporter_created).and_return notification_mailer
      post :create, params: { event_id: event.id, id: support_type.id, supporter: { comments: 'lorem ipsum' } }
    end

    describe 'response' do
      subject { response }

      it { is_expected.to redirect_to event_support_path(event) }
    end

    it 'creates supporter' do
      expect(support_type.supporters.find_by(seller: seller)).to be_present
    end

    it 'sends notification mail' do
      expect(NotificationMailer).to have_received(:supporter_created).with(instance_of(Supporter))
      expect(notification_mailer).to have_received(:deliver_later)
    end
  end
end
