# frozen_string_literal: true

module Admin
  class StockItemsController < AdminController
    def index
      @stock_items = current_client.stock_items.all
    end

    def new
      @stock_item = current_client.stock_items.build
    end

    def create
      @stock_item = current_client.stock_items.build stock_item_params
      if @stock_item.save
        redirect_to admin_stock_items_path, notice: t('.success')
      else
        render :new
      end
    end

    def edit
      @stock_item = current_client.stock_items.find params[:id]
    end

    def update
      @stock_item = current_client.stock_items.find params[:id]
      if @stock_item.update stock_item_edit_params
        redirect_to admin_stock_items_path, notice: t('.success')
      else
        render :edit
      end
    end

    def print
      stock_items = current_client.stock_items.all
      decorators = stock_items.map { |stock_item| StockLabelDecorator.new(stock_item) }
      pdf = LabelDocument.new(decorators).render
      send_data pdf, filename: 'stammartikel.pdf', type: 'application/pdf'
    end

    private

    def stock_item_params
      params.require(:stock_item).permit(:price, :description)
    end

    def stock_item_edit_params
      params.require(:stock_item).permit(:description)
    end
  end
end
