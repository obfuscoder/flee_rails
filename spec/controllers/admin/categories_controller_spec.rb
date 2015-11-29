require 'rails_helper'

module Admin
  RSpec.describe CategoriesController do
    include Sorcery::TestHelpers::Rails::Controller
    let(:user) { create :user }
    before { login_user user }

    let(:category) { create :category }

    describe 'GET new' do
      before { get :new }
      describe 'response' do
        subject { response }
        it { is_expected.to render_template :new }
        it { is_expected.to have_http_status :ok }
      end
      describe '@category' do
        subject { assigns :category }
        it { is_expected.to be_a_new Category }
      end
    end

    describe 'PUT update' do
      let(:params) { { name: 'My Category', max_items_per_seller: 5 } }
      before { put :update, id: category.id, category: params }

      it 'redirects to index path' do
        expect(response).to redirect_to admin_categories_path
      end

      it 'stores max_items_per_seller' do
        expect(category.reload.max_items_per_seller).to eq 5
      end
    end
  end
end