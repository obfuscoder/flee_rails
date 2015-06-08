class ItemsController < ApplicationController
  before_action :set_item, only: [:edit, :update, :destroy]
  before_action :set_vars

  def set_vars
    @seller = current_seller
    @event = Event.find params[:event_id]
    @reservation = Reservation.find_by_event_id_and_seller_id @event.id, @seller.id
  end

  def index
    @items = @reservation.items
  end

  def new
    @item = Item.new
  end

  def edit
    redirect_to event_items_path(@event), alert: t('.error.labeled') if @item.code.present?
  end

  def create
    @item = @reservation.items.build item_params

    if @item.save
      redirect_to event_items_path(@event), notice: t('.success')
    else
      render :new
    end
  end

  def update
    if @item.update(item_params)
      redirect_to event_items_path(@event), notice: t('.success')
    else
      render :edit
    end
  end

  def destroy
    @item.destroy
    redirect_to event_items_path(@event), notice: t('.success')
  end

  private

  def set_item
    @item = Item.find(params[:id])
    fail UnauthorizedError if @item.reservation.seller != current_seller
  end

  def item_params
    params.require(:item).permit(:category_id, :description, :size, :price)
  end
end
