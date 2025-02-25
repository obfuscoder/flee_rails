class ApplicationController < ActionController::Base
  before_action :log_client
  before_action :init_page_parameter
  before_action :init_sort_parameter
  before_action :log_current_user

  helper_method :searchable?

  include ApplicationHelper

  protect_from_forgery with: :exception, prepend: true

  class UnauthorizedError < StandardError; end

  rescue_from UnauthorizedError do
    render file: Rails.root.join('public/401.html'), status: :unauthorized
  end

  rescue_from ActionView::MissingTemplate, with: :not_acceptable

  rescue_from ActionController::RoutingError, with: :not_acceptable

  def not_found
    render file: Rails.root.join('public/404.html'), status: :not_found
  end

  def not_acceptable; end

  private

  def current_seller
    @current_seller ||= (Seller.find session[:seller_id] if session[:seller_id])
    raise UnauthorizedError unless @current_seller

    @current_seller
  end

  def current_seller?
    @current_seller || (Seller.find session[:seller_id] if session[:seller_id])
  end

  def only_with_reservation
    redirect_to seller_path, alert: t('.error.no_reservation') if
        current_seller.reservations.where(event: @event).empty?
  end

  def only_after_event_passed
    redirect_to seller_path, alert: t('.error.event_ongoing') unless @event.past?
  end

  def destroy_reservations(reservations)
    reservations.each do |reservation|
      reservation.destroy
      auto_reserve(reservation.event.reload)
    end
  end

  def auto_reserve(event)
    reservation_count = event.reservations.count
    return unless reservation_count < event.max_reservations

    event.notifications.order(:id).limit(event.max_reservations - reservation_count).each do |notification|
      CreateReservation.new.call Reservation.new(event: event, seller: notification.seller)
    end
  end

  def log_current_user
    Rails.logger.info "Current user is #{current_user.email}" if current_user
  end

  def log_client
    Rails.logger.info "Current client is #{current_client.try(:key)}"
  end

  def init_page_parameter
    init_query_session_parameter :page, 1
  end

  def init_sort_parameter
    init_query_session_parameter :sort, 'id'
    init_query_session_parameter :dir, 'asc'
  end

  def init_query_session_parameter(parameter, default = nil)
    session_param_name = "#{controller_name}_#{parameter}"
    session[session_param_name] = params[parameter] || session[session_param_name] || default
    instance_variable_set "@#{parameter}", session[session_param_name]
  end

  def column_order
    column_name = @sort
    direction = @dir
    return "#{column_name} #{direction}" if column_name.include? '.'

    { column_name => direction }
  end

  def searchable?
    false
  end

  # we ensure to raise exception when translation is missing
  def t(*args)
    unless Rails.env.production?
      if args.last.is_a? Hash
        args.last[:raise] = true
      else
        args << { raise: true }
      end
    end
    super(*args)
  end
end
