class ItemsController < ApplicationController
  before_action :set_vars
  before_action :set_item, only: [:edit, :update, :destroy, :delete_code]
  before_action :forbid_when_labeled, only: [:edit, :update, :destroy]
  before_action :init_categories, only: [:edit, :new, :update, :create]

  def index
    @items = @reservation.items.search(params[:search]).page(@page).joins(:category).order(column_order)
  end

  def new
    @item = Item.new donation: brand_settings.donation_of_unsold_items_default
  end

  def edit; end

  def create
    @item = @reservation.items.build item_params

    if @item.save
      redirect_to event_reservation_items_path(@event, @reservation), notice: t('.success')
    else
      render :new
    end
  end

  def update
    if @item.update item_params
      redirect_to event_reservation_items_path(@event, @reservation), notice: t('.success')
    else
      render :edit
    end
  end

  def destroy
    @item.destroy
    redirect_to event_reservation_items_path(@event, @reservation), notice: t('.success')
  end

  def delete_code
    @item.delete_code
    redirect_to event_reservation_items_path(@event, @reservation), notice: t('.success')
  end

  private

  def init_categories
    @categories = Category.selectable.order(:name).map do |category|
      [
        category.name,
        category.id,
        data: { donation_enforced: category.donation_enforced? }
      ]
    end
  end

  def set_vars
    @seller = current_seller
    @event = Event.find params[:event_id]
    @reservation = Reservation.find_by_id_and_event_id_and_seller_id params[:reservation_id], @event.id, @seller.id
  end

  def set_item
    @item = Item.find(params[:id])
    raise UnauthorizedError if @item.reservation.seller != current_seller
  end

  def forbid_when_labeled
    return unless @item.code.present?
    redirect_to event_reservation_items_path(@event.id, @reservation.id), alert: t('.error.labeled')
  end

  def item_params
    enforce_donation params.require(:item).permit(:category_id, :description, :size, :price, :donation)
  end

  def enforce_donation(parameters)
    return parameters unless brand_settings.donation_of_unsold_items_enabled && parameters['category_id'].present?
    category = Category.find parameters['category_id']
    parameters['donation'] = '1' if category.donation_enforced
    parameters
  end

  def searchable?
    action_name == 'index'
  end
end
