class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  class UnauthorizedError < StandardError; end

  rescue_from UnauthorizedError do
    render '/public/401', status: :unauthorized
  end

  private

  def current_seller_id
    session[:seller_id]
  end

  def current_seller
    @current_seller ||= (Seller.find current_seller_id if current_seller_id)
    fail UnauthorizedError unless @current_seller
    @current_seller
  end
end
