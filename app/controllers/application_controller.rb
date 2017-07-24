# frozen_string_literal: true

class ApplicationController < ActionController::Base
  before_filter :log_brand
  before_filter :connect_to_database
  before_filter :init_page_parameter
  before_filter :init_sort_parameter
  before_filter :log_current_user

  helper_method :searchable?

  include ApplicationHelper

  protect_from_forgery with: :exception

  class UnauthorizedError < StandardError; end

  rescue_from UnauthorizedError do
    render file: '/public/401', status: :unauthorized
  end

  private

  def create_label_document(items)
    items.without_label.each do |item|
      item.create_code prefix: brand_settings.prefix
      item.save! context: :generate_label
    end
    LabelDocument.new(label_decorators(items), with_donation: true).render
  end

  def label_decorators(items)
    items.map { |item| LabelDecorator.new item }
  end

  def current_seller
    @current_seller ||= (Seller.find session[:seller_id] if session[:seller_id])
    raise UnauthorizedError unless @current_seller
    @current_seller
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
      notify_for_available_reservations(reservation.event)
    end
  end

  def notify_for_available_reservations(event)
    return unless event.reservations.count < event.max_sellers
    Notification.where(event: event).each do |notification|
      SellerMailer.notification(notification, host: request.host, from: brand_settings.mail.from).deliver_later
      notification.destroy
    end
  end

  def connect_to_database
    database = brand_settings.database
    return Rails.logger.warn 'No database switch!' unless database
    Rails.logger.info "Switching to database #{brand_settings.database.database}"
    ActiveRecord::Base.establish_connection(database.to_hash)
  end

  def log_current_user
    Rails.logger.info "Current user is #{current_user.email}" if current_user
  end

  def log_brand
    Rails.logger.info "Current brand is #{brand_key}"
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
end
