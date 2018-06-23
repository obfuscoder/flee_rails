# frozen_string_literal: true

require 'rails_helper'

module Admin
  RSpec.describe SizesController do
    include Sorcery::TestHelpers::Rails::Controller
    let(:user) { create :user }
    before { login_user user }

    let!(:category) { create :category }

    describe 'GET new' do
      before { get :new, category_id: category.id }
      describe 'response' do
        subject { response }
        it { is_expected.to render_template :new }
        it { is_expected.to have_http_status :ok }
      end
      describe '@size' do
        subject { assigns :size }
        it { is_expected.to be_a_new Size }
      end
    end

    describe 'GET edit' do
      let(:size) { create :size, category: category }
      before { get :edit, category_id: category.id, id: size.id }

      describe 'response' do
        subject { response }
        it { is_expected.to render_template :edit }
        it { is_expected.to have_http_status :ok }
      end
      describe '@size' do
        subject { assigns :size }
        it { is_expected.to eq size }
      end
    end

    describe 'PUT update' do
      let(:size) { create :size, category: category }
      let(:params) { { value: 'new size' } }
      before { put :update, id: size.id, size: params, category_id: category.id }

      it 'redirects to index path' do
        expect(response).to redirect_to admin_category_sizes_path(category)
      end

      it 'stores max_items_per_seller' do
        expect(size.reload.value).to eq 'new size'
      end
    end

    describe 'GET index' do
      let!(:sizes) { create_list :size, 5, category: category }
      before { get :index, category_id: category.id }

      describe 'response' do
        subject { response }
        it { is_expected.to render_template :index }
        it { is_expected.to have_http_status :ok }
      end
      describe '@sizes' do
        subject { assigns :sizes }
        it { is_expected.to have(sizes.count).items }
      end
    end
  end
end
