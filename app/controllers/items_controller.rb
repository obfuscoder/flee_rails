class ItemsController < ApplicationController
  before_action :set_vars
  before_action :set_item, only: [:edit, :update, :destroy]

  def set_vars
    @seller = current_seller
    @event = Event.find params[:event_id]
    @reservation = Reservation.find_by_event_id_and_seller_id @event.id, @seller.id
  end

  def index
    @items = @reservation.items.search(params[:search]).page(@page).joins(:category).order(column_order)
  end

  def new
    @item = Item.new donation: brand_settings.donation_of_unsold_items_enabled
  end

  def edit
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
    redirect_to event_items_path(@event.id), alert: t('.error.labeled') if @item.code.present?
  end

  def item_params
    enforce_donation params.require(:item).permit(:category_id, :description, :size, :price, :donation)
  end

  def enforce_donation(parameters)
    return parameters unless brand_settings.donation_of_unsold_items_enabled
    category = Category.find parameters['category_id']
    parameters['donation'] = '1' if category.donation_enforced
    parameters
  end

  def searchable?
    action_name == 'index'
  end
end
