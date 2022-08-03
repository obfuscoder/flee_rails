require 'rails_helper'

module Admin
  RSpec.describe ResetPasswordController do
    describe 'GET new' do
      before { get :new }

      describe 'response' do
        subject { response }

        it { is_expected.to have_http_status(:ok) }
        it { is_expected.to render_template(:new) }
      end
    end

    describe 'POST create' do
      let(:user) { create :user }
      let(:notification_mailer) { double deliver_now: nil }

      before do
        allow(NotificationMailer).to receive(:reset_password_instructions).and_return notification_mailer
        post :create, params: { reset_password: { email: email } }
      end

      context 'when provided email is known' do
        let(:email) { user.email }

        it 'creates password reset token' do
          expect(user.reload.reset_password_token).to be_present
        end

        it 'triggers notification mail with token' do
          expect(NotificationMailer).to have_received(:reset_password_instructions).with(user)
          expect(notification_mailer).to have_received(:deliver_now)
        end

        describe 'response' do
          subject { response }

          it { is_expected.to redirect_to admin_login_path }
        end

        describe 'flash[:notice]' do
          subject { flash[:notice] }

          it { is_expected.to include email }
        end
      end

      context 'when provided email is unknown' do
        let(:email) { 'unknown@example.com' }

        describe 'response' do
          subject { response }

          it { is_expected.to redirect_to new_admin_reset_password_path }
        end

        describe 'flash[:alert]' do
          subject { flash[:alert] }

          it { is_expected.to include email }
        end
      end
    end

    describe 'GET edit' do
      let(:user) { create :user }

      before { get :edit, params: { token: token } }

      context 'with valid token' do
        let(:token) do
          user.generate_reset_password_token!
          user.reset_password_token
        end

        describe 'response' do
          subject { response }

          it { is_expected.to have_http_status(:ok) }
          it { is_expected.to render_template(:edit) }
        end

        describe '@token' do
          subject { assigns :token }

          it { is_expected.to eq token }
        end
      end

      context 'with invalid token' do
        let(:token) { 'invalid_token' }

        describe 'response' do
          subject { response }

          it { is_expected.to redirect_to admin_login_path }
        end

        describe 'flash[:alert]' do
          subject { flash[:alert] }

          it { is_expected.to be_present }
        end
      end
    end

    describe 'POST update' do
      let(:user) { create :user }
      let(:token) { user.reset_password_token }
      let(:password) { 'abCD1234' }
      let(:password_confirmation) { password }

      before { user.generate_reset_password_token! }

      before do
        post :update, params: {
          token: token,
          user: { password: password, password_confirmation: password_confirmation }
        }
      end

      describe 'response' do
        subject { response }

        it { is_expected.to redirect_to admin_login_path }
      end

      describe 'flash[:notice]' do
        subject { flash[:notice] }

        it { is_expected.to include user.email }
      end

      context 'with invalid token' do
        let(:token) { 'invalid_token' }

        describe 'response' do
          subject { response }

          it { is_expected.to redirect_to admin_login_path }
        end

        describe 'flash[:alert]' do
          subject { flash[:alert] }

          it { is_expected.to be_present }
        end
      end

      context 'with weak password' do
        let(:password) { '12345' }

        describe 'response' do
          subject { response }

          it { is_expected.to render_template 'edit' }
        end

        describe '@user' do
          subject { assigns :user }

          it { is_expected.to eq user }
        end
      end

      context 'with mismatching passwords' do
        let(:password_confirmation) { '54BCad' }

        describe 'response' do
          subject { response }

          it { is_expected.to render_template 'edit' }
        end

        describe '@user' do
          subject { assigns :user }

          it { is_expected.to eq user }
        end
      end
    end
  end
end
