require 'rails_helper'



RSpec.describe CategoriesController do
  let!(:category) { FactoryGirl.create(:category) }

  describe "GET index" do
    before do
      get :index
    end

    it "assigns all categories as @categories" do
      expect(assigns(:categories)).to match_array([category])
    end

    it { expect(response).to render_template("index") }
    it { expect(response).to have_http_status :ok }
  end

  describe "GET show" do
    before do
      get :show, id: category.to_param
    end

    it "assigns the requested category as @category" do
      expect(assigns(:category)).to eq(category)
    end

    it { expect(response).to render_template("show") }
    it { expect(response).to have_http_status :ok }
  end

  describe "GET new" do
    before do
      get :new
    end

    it "assigns a new category as @category" do
      expect(assigns(:category)).to be_a_new(Category)
    end

    it { expect(response).to render_template("new") }
    it { expect(response).to have_http_status :ok }
  end

  describe "GET edit" do
    before do
      get :edit, id: category.to_param
    end

    it "assigns the requested category as @category" do
      expect(assigns(:category)).to eq(category)
    end

    it { expect(response).to render_template("edit") }
    it { expect(response).to have_http_status :ok }
  end

  describe "POST create" do
    context "with valid params" do
      def create_category
        post :create, category: FactoryGirl.attributes_for(:category)
      end

      before do
        create_category
      end

      it "creates a new Category" do
        expect { create_category }.to change(Category, :count).by(1)
      end

      it { expect(assigns(:category)).to be_a(Category) }
      it { expect(assigns(:category)).to be_persisted }
      it { expect(response).to redirect_to(Category.last) }
    end

    describe "with invalid params" do
      before do
        post :create, category: {name: nil}
      end

      it { expect(assigns(:category)).to be_a_new(Category) }
      it { expect(assigns(:category)).not_to be_persisted }
      it { expect(response).to render_template("new") }
      it { expect(response).to have_http_status :ok }
    end
  end

  describe "PUT update" do
    before do
      put :update, id: category.to_param, category: new_attributes
      category.reload
    end

    context "with valid params" do
      let(:new_attributes) { FactoryGirl.attributes_for(:category) }

      it { expect(category.name).to eq(new_attributes[:name]) }
      it { expect(assigns(:category)).to eq(category) }
      it { expect(response).to redirect_to(category) }
    end

    context "with invalid params" do
      let(:new_attributes) { { name: nil } }

      it { expect(assigns(:category)).to eq(category) }
      it { expect(response).to render_template("edit") }
      it { expect(response).to have_http_status :ok }
    end
  end

  describe "DELETE destroy" do
    let(:delete_category) { delete :destroy, id: category.to_param }

    it { expect { delete_category }.to change(Category, :count).by(-1) }

    it "redirects to the categories list" do
      delete_category
      expect(response).to redirect_to(categories_path)
    end
  end
end
