# frozen_string_literal: true

class DataExtractor
  def initialize(data = {})
    @data = data
  end

  delegate :name, :first_name, :last_name, :street, :zip_code, :city, :phone, :email, to: :seller, prefix: true
  delegate :name, :max_reservations, :max_items_per_reservation, :max_reservations_per_seller, to: :event, prefix: true
  delegate :number, to: :reservation, prefix: true
  delegate :comments, to: :supporter, prefix: true
  delegate :name, to: :support_type, prefix: true
  delegate :number, to: :bill, prefix: true

  def registration_info
    <<~DATA
      #{seller_first_name} #{seller_last_name}
      #{seller_street}
      #{seller_zip_code} #{seller_city}
      Tel.: #{seller_phone}
      Mail: #{seller_email}
    DATA
  end

  def login_url
    urls[:login]
  end

  def reserve_url
    urls[:reserve]
  end

  def results_url
    urls[:results]
  end

  def review_url
    urls[:review]
  end

  def event_shopping_time
    ApplicationController.helpers.shopping_time(event)
  end

  def event_handover_time
    ApplicationController.helpers.handover_time(event)
  end

  def event_pickup_time
    ApplicationController.helpers.pickup_time(event)
  end

  def event_reservation_end
    l(event.reservation_end)
  end

  def event_reservation_start
    l(event.reservation_start)
  end

  def event_commission_rate
    ApplicationController.helpers.number_to_percentage event.commission_rate * 100, precision: 0
  end

  def event_reservation_fee
    ApplicationController.helpers.number_to_currency(event.reservation_fee)
  end

  def name
    @data[:name]
  end

  def email
    @data[:email]
  end

  def subject
    @data[:subject]
  end

  def body
    @data[:body]
  end

  private

  def seller
    @data[:seller]
  end

  def event
    @data[:event]
  end

  def reservation
    @data[:reservation]
  end

  def supporter
    @data[:supporter]
  end

  def support_type
    @data[:support_type]
  end

  def bill
    @data[:bill]
  end

  def urls
    @data[:urls]
  end

  def position
    @data[:position]
  end

  def l(text)
    ApplicationController.helpers.localize text
  end
end
