# frozen_string_literal: true

require 'rails_helper'

module Admin
  RSpec.describe StockItemsController do
    include Sorcery::TestHelpers::Rails::Controller
    let(:user) { create :user }
    before { login_user user }

    describe 'GET index' do
      before { allow(StockItem).to receive(:all).and_return stock_items }
      let(:stock_items) { double }
      before { get :index }

      subject { response }

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
      let(:stock_item) { double save: saved }
      let(:saved) { true }
      before { allow(StockItem).to receive(:new).and_return stock_item }
      before { post :create, stock_item: { price: price, description: description } }

      describe 'response' do
        subject { response }
        it { is_expected.to redirect_to(admin_stock_items_path) }
      end

      describe 'notice flash' do
        subject { flash[:notice] }
        it { is_expected.not_to be_empty }
      end

      it 'saves new stock item' do
        expect(StockItem).to have_received(:new).with(price: price, description: description)
      end

      context 'when creation failed' do
        let(:saved) { false }

        describe 'response' do
          subject { response }
          it { is_expected.to render_template :new }
          it { is_expected.to have_http_status :ok }
        end

        describe '@stock_item' do
          subject { assigns :stock_item }
          it { is_expected.to eq stock_item }
        end
      end
    end

    describe 'GET edit' do
      let(:stock_item) { double id: 5 }
      before { allow(StockItem).to receive(:find).with(stock_item.id.to_s).and_return(stock_item) }
      before { get :edit, id: stock_item.id }

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
      let(:stock_item) { double id: 2, update: updated }
      let(:updated) { true }
      before { allow(StockItem).to receive(:find).with(stock_item.id.to_s).and_return(stock_item) }
      before { put :update, id: stock_item.id, stock_item: { description: description, price: price } }

      describe 'response' do
        subject { response }
        it { is_expected.to redirect_to admin_stock_items_path }
      end

      describe 'notice flash' do
        subject { flash[:notice] }
        it { is_expected.not_to be_empty }
      end

      it 'updates stock item' do
        expect(stock_item).to have_received(:update).with(description: description)
      end

      context 'when update failed' do
        let(:updated) { false }

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
    end

    describe 'GET print' do
      before do
        expect(StockItem).to receive(:all).and_return([stock_item])
        expect(LabelDocument).to receive(:new).and_return(label_document)
        expect(StockLabelDecorator).to receive(:new).with(stock_item)
      end
      let(:stock_item) { double }
      let(:label_document) { double render: pdf }
      let(:pdf) { 'pdf content' }
      before { get :print }

      describe 'response' do
        subject { response }
        it { is_expected.to have_http_status :ok }
        its(:content_type) { is_expected.to eq 'application/pdf' }
        its(:body) { is_expected.to eq pdf }
      end
    end
  end
end
