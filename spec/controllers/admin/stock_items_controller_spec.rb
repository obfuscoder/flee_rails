require 'rails_helper'

module Admin
  RSpec.describe StockItemsController do
    include Sorcery::TestHelpers::Rails::Controller
    let(:user) { create :user }

    before { login_user user }

    describe 'GET index' do
      subject { response }

      let(:stock_items) { create_list :stock_item, 3 }

      before { get :index }

      it { is_expected.to render_template :index }
      it { is_expected.to have_http_status :ok }

      describe '@stock_items' do
        subject { assigns :stock_items }

        it { is_expected.to eq stock_items }
      end
    end

    describe 'GET new' do
      before { get :new }

      describe 'response' do
        subject { response }

        it { is_expected.to render_template :new }
        it { is_expected.to have_http_status :ok }
      end

      describe '@stock_item' do
        subject { assigns :stock_item }

        it { is_expected.to be_a_new StockItem }
      end
    end

    describe 'POST create' do
      let(:price) { '2.5' }
      let(:description) { 'some description' }
      let(:saved) { true }

      before { post :create, params: { stock_item: { price: price, description: description } } }

      describe 'response' do
        subject { response }

        it { is_expected.to redirect_to(admin_stock_items_path) }
      end

      describe 'notice flash' do
        subject { flash[:notice] }

        it { is_expected.not_to be_empty }
      end

      it 'saves new stock item' do
        expect(StockItem.first).to have_attributes(description: description)
      end
    end

    describe 'GET edit' do
      let(:stock_item) { create :stock_item }

      before { get :edit, params: { id: stock_item.id } }

      describe 'response' do
        subject { response }

        it { is_expected.to render_template :edit }
        it { is_expected.to have_http_status :ok }
      end

      describe '@stock_item' do
        subject { assigns :stock_item }

        it { is_expected.to eq stock_item }
      end
    end

    describe 'PUT update' do
      let(:price) { '2.5' }
      let(:description) { 'some description' }
      let(:stock_item) { create :stock_item }

      before { put :update, params: { id: stock_item.id, stock_item: { description: description, price: price } } }

      describe 'response' do
        subject { response }

        it { is_expected.to redirect_to admin_stock_items_path }
      end

      describe 'notice flash' do
        subject { flash[:notice] }

        it { is_expected.not_to be_empty }
      end

      it 'updates stock item' do
        expect(stock_item.reload).to have_attributes(description: description)
      end
    end

    describe 'GET print' do
      let(:stock_item) { create :stock_item }
      let(:label_document) { double render: pdf }
      let(:pdf) { 'pdf content' }

      before do
        allow(LabelDocument).to receive(:new).and_return(label_document)
        allow(StockLabelDecorator).to receive(:new).with(stock_item)
        get :print
      end

      describe 'response' do
        subject { response }

        it { is_expected.to have_http_status :ok }
        its(:content_type) { is_expected.to eq 'application/pdf' }
        its(:body) { is_expected.to eq pdf }
      end
    end
  end
end
