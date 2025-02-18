require 'rails_helper'

RSpec.describe Admin::SupportTypesController do
  include Sorcery::TestHelpers::Rails::Controller
  let(:user) { create :user }
  let(:event) { create :event }

  before { login_user user }

  describe 'GET index' do
    let!(:support_types) { create_list :support_type, 5, event: event }

    before { get :index, params: { event_id: event.id } }

    describe 'response' do
      subject { response }

      it { is_expected.to render_template :index }
      it { is_expected.to have_http_status :ok }
    end

    describe '@event' do
      subject { assigns :event }

      it { is_expected.to eq event }
    end

    describe '@support_types' do
      subject { assigns :support_types }

      it { is_expected.to eq support_types }
    end
  end

  describe 'GET new' do
    before { get :new, params: { event_id: event.id } }

    describe 'response' do
      subject { response }

      it { is_expected.to render_template :new }
      it { is_expected.to have_http_status :ok }
    end

    describe '@event' do
      subject { assigns :event }

      it { is_expected.to eq event }
    end

    describe '@support_type' do
      subject { assigns :support_type }

      it { is_expected.to be_a_new SupportType }
    end
  end

  describe 'POST create' do
    let(:params) { { name: 'name', description: 'description', capacity: 46 } }

    before { post :create, params: { event_id: event.id, support_type: params } }

    describe 'response' do
      subject { response }

      it { is_expected.to redirect_to admin_event_support_types_path(event) }
    end

    it 'creates new support type' do
      created_support_type = event.support_types.last
      expect(created_support_type).to have_attributes name: 'name', description: 'description', capacity: 46
    end

    context 'with invalid params' do
      let(:params) { { description: 'description' } }

      describe 'response' do
        subject { response }

        it { is_expected.to render_template :new }
        it { is_expected.to have_http_status :ok }
      end

      describe '@event' do
        subject { assigns :event }

        it { is_expected.to eq event }
      end

      describe '@support_type' do
        subject { assigns :support_type }

        it { is_expected.to be_a_new SupportType }
      end
    end
  end

  describe 'GET edit' do
    let(:support_type) { create :support_type, event: event }

    before { get :edit, params: { event_id: event.id, id: support_type.id } }

    describe 'response' do
      subject { response }

      it { is_expected.to render_template :edit }
      it { is_expected.to have_http_status :ok }
    end

    describe '@event' do
      subject { assigns :event }

      it { is_expected.to eq event }
    end

    describe '@support_type' do
      subject { assigns :support_type }

      it { is_expected.to eq support_type }
    end
  end

  describe 'PUT update' do
    let(:support_type) { create :support_type, event: event }
    let(:params) { { name: 'name', description: 'description', capacity: 46 } }

    before { put :update, params: { event_id: event.id, id: support_type.id, support_type: params } }

    describe 'response' do
      subject { response }

      it { is_expected.to redirect_to admin_event_support_types_path(event) }
    end

    it 'updates the support type' do
      expect(support_type.reload).to have_attributes name: 'name', description: 'description', capacity: 46
    end

    context 'with invalid params' do
      let(:params) { { capacity: -3 } }

      describe 'response' do
        subject { response }

        it { is_expected.to render_template :edit }
        it { is_expected.to have_http_status :ok }
      end

      describe '@event' do
        subject { assigns :event }

        it { is_expected.to eq event }
      end

      describe '@support_type' do
        subject { assigns :support_type }

        it { is_expected.to eq support_type }
      end
    end
  end

  describe 'DELETE destroy' do
    let(:support_type) { create :support_type, event: event }

    before { delete :destroy, params: { event_id: event.id, id: support_type.id } }

    describe 'response' do
      subject { response }

      it { is_expected.to redirect_to admin_event_support_types_path(event) }
    end

    it 'destroys the support type' do
      expect { support_type.reload }.to raise_error ActiveRecord::RecordNotFound
    end
  end

  describe 'GET print' do
    let!(:support_types) { create_list :support_type, 5, event: event }
    let(:document) { double render: pdf }
    let(:pdf) { 'pdf content' }

    before do
      allow(SupportTypesDocument).to receive(:new).with(event, support_types).and_return document
      get :print, params: { event_id: event.id }
    end

    describe 'response' do
      subject { response }

      it { is_expected.to have_http_status :ok }
      its(:media_type) { is_expected.to eq 'application/pdf' }
      its(:body) { is_expected.to eq pdf }
    end
  end
end
