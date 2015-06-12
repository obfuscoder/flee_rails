class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  class UnauthorizedError < StandardError; end

  rescue_from UnauthorizedError do
    render file: '/public/401', status: :unauthorized
  end

  private

  def create_reservation(event_id)
    reservation = Reservation.create event_id: event_id, seller: current_seller
    if reservation.persisted?
      redirect_to seller_path, notice: t('.success', number: reservation.number)
    else
      redirect_to seller_path, alert: t('.failure')
    end
  end

  def current_seller
    @current_seller ||= (Seller.find session[:seller_id] if session[:seller_id])
    fail UnauthorizedError unless @current_seller
    @current_seller
  end
end
