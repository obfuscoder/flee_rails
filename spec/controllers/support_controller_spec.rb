# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SupportController do
  let(:seller) { create :seller }
  let!(:event) { create :event_with_support }
  before { session[:seller_id] = seller.id }
  describe 'GET index' do
    before { get :index, event_id: event.id }

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
    before { get :new, event_id: event.id, id: support_type.id }

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
    before do
      supporter
      delete :destroy, event_id: event.id, id: support_type.id
    end

    describe 'response' do
      subject { response }
      it { is_expected.to redirect_to event_support_path(event) }
    end

    it 'destroys supporter' do
      expect{ supporter.reload }.to raise_error ActiveRecord::RecordNotFound
    end
  end

  describe 'POST create' do
    let(:support_type) { event.support_types.first }
    before { post :create, event_id: event.id, id: support_type.id, supporter: { comments: 'lorem ipsum' } }

    describe 'response' do
      subject { response }
      it { is_expected.to redirect_to event_support_path(event) }
    end

    it 'creates supporter' do
      expect(support_type.supporters.find_by(seller: seller)).to be_present
    end
  end
end
