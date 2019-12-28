require 'rails_helper'

RSpec.describe Admin::SupportersController do
  include Sorcery::TestHelpers::Rails::Controller
  let(:user) { create :user }
  let(:event) { create :event }
  let(:support_type) { create :support_type, event: event }

  before { login_user user }

  describe 'GET index' do
    let!(:supporters) { create_list :supporter, 5, support_type: support_type }

    before { get :index, params: { event_id: event.id, support_type_id: support_type.id } }

    describe 'response' do
      subject { response }

      it { is_expected.to render_template :index }
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

    describe '@supporters' do
      subject { assigns :supporters }

      it { is_expected.to have(supporters.count).items }
    end
  end

  describe 'GET new' do
    before { get :new, params: { event_id: event.id, support_type_id: support_type.id } }

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

      it { is_expected.to eq support_type }
    end

    describe '@supporter' do
      subject { assigns :supporter }

      it { is_expected.to be_a_new Supporter }
    end
  end

  describe 'POST create' do
    let(:seller) { create :seller }
    let(:params) { { seller_id: seller.id, comments: 'comments' } }

    before { post :create, params: { event_id: event.id, support_type_id: support_type.id, supporter: params } }

    describe 'response' do
      subject { response }

      it { is_expected.to redirect_to admin_event_support_type_supporters_path(event, support_type) }
    end

    it 'creates new supporter' do
      created_supporter = support_type.supporters.last
      expect(created_supporter).to have_attributes comments: 'comments', seller: seller
    end

    context 'with invalid params' do
      let(:params) { { comments: 'comments' } }

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

        it { is_expected.to eq support_type }
      end

      describe '@supporter' do
        subject { assigns :supporter }

        it { is_expected.to be_a_new Supporter }
      end
    end
  end

  describe 'GET edit' do
    let!(:existing_supporter) { create :supporter, support_type: support_type }
    let!(:available_seller) { create :seller }
    let(:supporter) { create :supporter, support_type: support_type }
    let(:current_seller) { supporter.seller }

    before { get :edit, params: { event_id: event.id, support_type_id: support_type.id, id: supporter.id } }

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

    describe '@supporter' do
      subject { assigns :supporter }

      it { is_expected.to eq supporter }
    end
  end

  describe 'PUT update' do
    let(:supporter) { create :supporter, support_type: support_type }
    let(:params) { { comments: 'comments' } }

    before do
      put :update, params: { event_id: event.id, support_type_id: support_type.id, id: supporter.id, supporter: params }
    end

    describe 'response' do
      subject { response }

      it { is_expected.to redirect_to admin_event_support_type_supporters_path(event, support_type) }
    end

    it 'updates the supporter' do
      expect(supporter.reload).to have_attributes comments: 'comments'
    end
  end

  describe 'DELETE destroy' do
    let(:supporter) { create :supporter, support_type: support_type }

    before { delete :destroy, params: { event_id: event.id, support_type_id: support_type.id, id: supporter.id } }

    describe 'response' do
      subject { response }

      it { is_expected.to redirect_to admin_event_support_type_supporters_path(event, support_type) }
    end

    it 'destroys the supporter' do
      expect { supporter.reload }.to raise_error ActiveRecord::RecordNotFound
    end
  end
end
