require 'label_document'

class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  class UnauthorizedError < StandardError; end

  rescue_from UnauthorizedError do
    render file: '/public/401', status: :unauthorized
  end

  private

  def create_reservation(event_id)
    event = Event.find event_id
    reservation = Reservation.create event: event, seller: current_seller
    if reservation.persisted?
      redirect_to seller_path, notice: t('.success', number: reservation.number)
    else
      redirect_to seller_path, alert: t('.failure', reason: reservation.errors.messages.values.join(','))
    end
  end

  def create_label_document(items)
    items.without_label.each do |item|
      item.create_code
      item.save!
    end
    LabelDocument.new(label_decorators(items)).render
  end

  def label_decorators(items)
    items.map do |item|
      {
        number: "#{item.reservation.number} - #{item.number}",
        price: view_context.number_to_currency(item.price),
        details: "#{item.category}\n#{item.description}" + (item.size ? "\nGröße: #{item.size}" : ''),
        code: item.code
      }
    end
  end

  def current_seller
    @current_seller ||= (Seller.find session[:seller_id] if session[:seller_id])
    fail UnauthorizedError unless @current_seller
    @current_seller
  end

  def only_with_reservation
    redirect_to seller_path, alert: t('.error.no_reservation') if
        current_seller.reservations.where(event: @event).empty?
  end

  def only_after_event_passed
    redirect_to seller_path, alert: t('.error.event_ongoing') unless @event.shopping_end.past?
  end

  def destroy_reservations(reservations)
    reservations.each do |reservation|
      reservation.destroy
      notify_for_available_reservations(reservation.event)
    end
  end

  def notify_for_available_reservations(event)
    return unless event.reservations.count < event.max_sellers
    Notification.where(event: event).each do |notification|
      SellerMailer.notification(notification, host: request.host).deliver_later
      notification.destroy
    end
  end
end
