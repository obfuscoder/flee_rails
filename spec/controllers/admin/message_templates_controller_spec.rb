# frozen_string_literal: true

require 'rails_helper'

module Admin
  RSpec.describe MessageTemplatesController do
    include Sorcery::TestHelpers::Rails::Controller
    before { login_user create(:user) }

    describe 'GET index' do
      subject { response }

      before { get :index }

      it { is_expected.to render_template :index }
      it { is_expected.to have_http_status :ok }

      describe '@message_templates' do
        subject { assigns :message_templates }

        it { is_expected.to have(StockMessageTemplate.count).items }
      end
    end

    describe 'GET edit' do
      let(:message_template) { create :message_template }

      before { get :edit, params: { id: message_template.id } }

      describe 'response' do
        subject { response }

        it { is_expected.to render_template :edit }
        it { is_expected.to have_http_status :ok }
      end

      describe '@message_template' do
        subject { assigns :message_template }

        it { is_expected.to eq message_template }
      end
    end

    describe 'DELETE destroy' do
      let(:message_template) { create :message_template }

      before { delete :destroy, params: { id: message_template.id } }

      describe 'response' do
        subject { response }

        it { is_expected.to redirect_to admin_message_templates_path }
      end

      it 'destroys message template' do
        expect { message_template.reload }.to raise_error ActiveRecord::RecordNotFound
      end
    end

    describe 'PUT update' do
      let(:mail_subject) { 'new subject' }
      let(:body) { 'new body' }
      let(:message_template) { create :message_template }

      before do
        put :update, params: { id: message_template.id, message_template: { subject: mail_subject, body: body } }
      end

      describe 'response' do
        subject { response }

        it { is_expected.to redirect_to admin_message_templates_path }
      end

      it 'updates message template' do
        expect(message_template.reload).to have_attributes(subject: mail_subject, body: body)
      end
    end
  end
end
