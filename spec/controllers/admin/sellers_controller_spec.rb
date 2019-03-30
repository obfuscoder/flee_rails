# frozen_string_literal: true

require 'rails_helper'

module Admin
  RSpec.describe SellersController do
    include Sorcery::TestHelpers::Rails::Controller
    let(:user) { create :user }
    let!(:seller1) { create :seller, first_name: 'AAAAA', last_name: 'BBBB', email: 'zzz@bbb.de' }
    let!(:seller2) { create :seller, first_name: 'ZZZZZ', last_name: 'EEEE', email: 'bbb@bbb.de' }
    let!(:seller3) { create :seller, first_name: 'BBBBB', last_name: 'BBBB', email: 'aaa@bbb.de' }

    before { login_user user }

    describe 'GET index' do
      let(:params) { {} }

      before { get :index, params }

      its(:searchable?) { is_expected.to eq true }

      describe '@sellers' do
        subject { assigns :sellers }

        its(:first) { is_expected.to eq seller1 }

        context 'when search parameter is given' do
          let(:params) { { search: 'bbbb' } }

          its(:count) { is_expected.to eq 2 }
        end

        context 'when sort parameter is set to email' do
          let(:params) { { sort: 'email' } }

          its(:first) { is_expected.to eq seller3 }
        end

        context 'when sort parameter is set to name' do
          let(:params) { { sort: 'name' } }

          its(:first) { is_expected.to eq seller1 }
        end

        context 'when direction parameter is set to desc' do
          context 'when sort parameter is set to email' do
            let(:params) { { sort: 'email', dir: 'desc' } }

            its(:first) { is_expected.to eq seller1 }
          end

          context 'when sort parameter is set to name' do
            let(:params) { { sort: 'name', dir: 'desc' } }

            its(:first) { is_expected.to eq seller2 }
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

      describe '@seller' do
        subject { assigns :seller }

        it { is_expected.to be_a_new Seller }
      end

      describe '@available_numbers' do
        subject { assigns :available_numbers }

        it { is_expected.to be_nil }

        context 'when auto_reservation_numbers_start is configured for client' do
          let(:preparations) do
            Client.first.update! auto_reservation_numbers_start: 100
            more_preparations
          end
          let(:more_preparations) {}

          it { is_expected.to have(99).items }
          its(:first) { is_expected.to eq 1 }
          its(:last) { is_expected.to eq 99 }

          context 'when other seller already has default_reservation_number assigned' do
            let(:more_preparations) { create :seller, default_reservation_number: 1 }

            it { is_expected.to have(98).items }
            its(:first) { is_expected.to eq 2 }
          end
        end
      end
    end

    describe 'GET edit' do
      let(:preparations) {}
      let(:seller) { create :seller }

      before do
        preparations
        get :edit, id: seller.id
      end

      describe 'response' do
        subject { response }

        it { is_expected.to render_template :edit }
        it { is_expected.to have_http_status :ok }
      end

      describe '@seller' do
        subject { assigns :seller }

        it { is_expected.to eq seller }
      end

      describe '@available_numbers' do
        subject { assigns :available_numbers }

        it { is_expected.to be_nil }

        context 'when auto_reservation_numbers_start is configured for client' do
          let(:preparations) do
            Client.first.update! auto_reservation_numbers_start: 100
            more_preparations
          end
          let(:more_preparations) {}

          it { is_expected.to have(99).items }
          its(:first) { is_expected.to eq 1 }
          its(:last) { is_expected.to eq 99 }

          context 'when other seller already has default_reservation_number assigned' do
            let(:more_preparations) { create :seller, default_reservation_number: 1 }

            it { is_expected.to have(98).items }
            its(:first) { is_expected.to eq 2 }

            context 'when current seller already has a default_reservation_number assigned' do
              let(:seller) { create :seller, default_reservation_number: 2 }

              it { is_expected.to have(98).items }
              its(:first) { is_expected.to eq 2 }
            end
          end
        end
      end
    end
  end
end
