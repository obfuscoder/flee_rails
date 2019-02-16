# frozen_string_literal: true

class ItemsController < ApplicationController
  before_action :set_vars
  before_action :set_item, only: %i[edit update destroy delete_code]
  before_action :forbid_when_labeled, only: %i[edit update destroy]
  before_action :init_categories, only: %i[edit new update create]

  def index
    @items = @reservation.items.search(params[:search]).page(@page).joining { category.outer }.order(column_order)
  end

  def new
    @item = @reservation.items.build donation: current_client.donation_of_unsold_items_default
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
    @categories = current_client.categories.merge(Category.selectable).order(:name).map do |category|
      element = [
        category.name,
        category.id
      ]
      data = { size_option: category.size_option }
      data[:sizes] = category.sizes.map(&:value).join('|')
      data[:donation_enforced] = category.donation_enforced? if @event.donation_of_unsold_items_enabled
      element << { data: data } unless data.empty?
      element
    end
  end

  def set_vars
    @seller = current_seller
    @event = current_client.events.find params[:event_id]
    @reservation = @event.reservations.find_by id: params[:reservation_id], seller: @seller
  end

  def set_item
    @item = @reservation.items.find(params[:id])
  end

  def forbid_when_labeled
    return if @item.code.blank?

    redirect_to event_reservation_items_path(@event.id, @reservation.id), alert: t('.error.labeled')
  end

  def item_params
    enforce_donation params.require(:item).permit(:category_id, :description, :size, :price, :donation)
  end

  def enforce_donation(parameters)
    return parameters unless @reservation.event.donation_of_unsold_items_enabled && parameters['category_id'].present?

    category = current_client.categories.find parameters['category_id']
    parameters['donation'] = true if category.donation_enforced
    parameters
  end

  def searchable?
    action_name == 'index'
  end
end
