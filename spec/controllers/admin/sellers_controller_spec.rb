require 'rails_helper'

module Admin
  RSpec.describe SellersController do
    include Sorcery::TestHelpers::Rails::Controller
    let(:user) { FactoryGirl.create :user }
    before { login_user user }

    let!(:seller1) { FactoryGirl.create :seller, first_name: 'AAAAA', last_name: 'BBBB', email: 'zzz@bbb.de' }
    let!(:seller2) { FactoryGirl.create :seller, first_name: 'ZZZZZ', last_name: 'EEEE', email: 'bbb@bbb.de' }
    let!(:seller3) { FactoryGirl.create :seller, first_name: 'BBBBB', last_name: 'BBBB', email: 'aaa@bbb.de' }

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
  end
end
