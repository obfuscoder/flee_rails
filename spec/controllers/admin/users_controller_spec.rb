require 'rails_helper'

module Admin
  RSpec.describe UsersController do
    include Sorcery::TestHelpers::Rails::Controller
    let(:user) { User.first }

    before { login_user user }

    describe 'GET index' do
      let(:params) { {} }
      let!(:user1) { create :user, name: 'zzzz' }
      let!(:user2) { create :user, name: 'wwww' }
      let!(:user3) { create :user, name: 'yyyy' }

      before { get :index, params: params }

      its(:searchable?) { is_expected.to eq true }

      describe '@users' do
        subject { assigns :users }

        its(:first) { is_expected.to eq user }

        context 'when search parameter is given' do
          let(:params) { { search: 'www' } }

          its(:count) { is_expected.to eq 1 }
        end

        context 'when sort parameter is set to email' do
          let(:params) { { sort: 'email' } }

          its(:first) { is_expected.to eq user1 }
        end

        context 'when sort parameter is set to name' do
          let(:params) { { sort: 'name' } }

          its(:first) { is_expected.to eq user }
        end

        context 'when direction parameter is set to desc' do
          context 'when sort parameter is set to email' do
            let(:params) { { sort: 'email', dir: 'desc' } }

            its(:first) { is_expected.to eq user }
          end

          context 'when sort parameter is set to name' do
            let(:params) { { sort: 'name', dir: 'desc' } }

            its(:first) { is_expected.to eq user1 }
          end
        end
      end
    end

    describe 'GET new' do
      let(:preparations) {}

      before do
        preparations
        get :new
      end

      describe 'response' do
        subject { response }

        it { is_expected.to render_template :new }
        it { is_expected.to have_http_status :ok }
      end

      describe '@user' do
        subject { assigns :user }

        it { is_expected.to be_a_new User }
      end
    end

    describe 'POST create' do
      let(:preparations) {}
      let(:email) { Faker::Internet.email }
      let(:name) { Faker::Name.name }
      let(:notification_mailer) { double deliver_now: nil }
      let(:password) { 'Abc12345' }

      before do
        preparations
        allow(GeneratePassword).to receive(:execute).and_return(password)
        allow(NotificationMailer).to receive(:user_created).and_return(notification_mailer)
        post :create, params: { user: { email: email, name: name } }
      end

      describe 'response' do
        subject { response }

        it { is_expected.to redirect_to admin_users_path }
      end

      describe 'flash[:notice]' do
        subject { flash[:notice] }

        it { is_expected.to include name }
        it { is_expected.to include email }
      end

      it 'sends user_created email' do
        expect(NotificationMailer).to have_received(:user_created).with(instance_of(User), password)
        expect(notification_mailer).to have_received(:deliver_now)
      end
    end

    describe 'GET edit' do
      let(:preparations) {}
      let(:user) { create :user }

      before do
        preparations
        get :edit, params: { id: user.id }
      end

      describe 'response' do
        subject { response }

        it { is_expected.to render_template :edit }
        it { is_expected.to have_http_status :ok }
      end

      describe '@user' do
        subject { assigns :user }

        it { is_expected.to eq user }
      end
    end
  end
end
