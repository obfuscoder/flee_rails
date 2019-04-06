# frozen_string_literal: true

class ReservationsController < ApplicationController
  before_action :init_event
  before_action :init_reservation, only: %i[destroy import]

  def create
    reservation = CreateReservationOrder.new.call Reservation.new(event: @event, seller: current_seller)
    if reservation.errors.any?
      redirect_to seller_path, alert: t('.failure', reason: reservation.errors.full_messages.join(', '))
    else
      redirect_to seller_path, notice: t('.success')
    end
  end

  def destroy
    destroy_reservations([@reservation])
    redirect_to seller_path, notice: t('.success')
  end

  def import
    if request.post?
      @from_reservation = current_seller.reservations.find params[:import][:from_reservation]
      items = @from_reservation.items.find params[:import][:item]
      items_copied = items.count { |item| item.copy_to(@reservation).persisted? }
      redirect_to event_reservation_items_path(@event, @reservation), notice: t('.success', count: items_copied)
    else
      @reservations = @reservation.previous
    end
  end

  def import_from
    @reservation = @event.reservations.find_by(id: params[:reservation_id])
    @from_reservation = current_seller.reservations.find_by(id: params[:id])
    @items = @from_reservation.items.where(sold: nil).map do |item|
      [item.id, [item.category.name,
                 item.description,
                 item.size,
                 view_context.number_to_currency(item.price)].compact.join(', ')]
    end
  end

  private

  def init_event
    @event = current_client.events.find params[:event_id]
  end

  def init_reservation
    @reservation = @event.reservations.find_by(id: params[:id], seller: current_seller)
  end
end
