class ItemsController < ApplicationController
  before_action :set_item, only: [:edit, :update, :destroy]

  # GET /items
  # GET /items.json
  def index
    @seller = current_seller
    @items = current_seller.items
  end

  # GET /items/new
  def new
    @item = Item.new
  end

  # GET /items/1/edit
  def edit
    redirect_to items_path, alert: t('.error.labeled') if @item.labels.any?
  end

  # POST /items
  # POST /items.json
  def create
    @item = current_seller.items.build(item_params)

    if @item.save
      redirect_to items_path, notice: t('.success')
    else
      render :new
    end
  end

  # PATCH/PUT /items/1
  # PATCH/PUT /items/1.json
  def update
    if @item.update(item_params)
      redirect_to items_path, notice: t('.success')
    else
      render :edit
    end
  end

  # DELETE /items/1
  # DELETE /items/1.json
  def destroy
    @item.destroy
    redirect_to items_url, notice: t('.success')
  end

  private

  def set_item
    @item = Item.find(params[:id])
    fail UnauthorizedError if @item.seller != current_seller
  end

  def item_params
    params.require(:item).permit(:category_id, :description, :size, :price)
  end
end
