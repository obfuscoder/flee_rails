# frozen_string_literal: true

class DataExtractor
  def initialize(data = {})
    @data = data
  end

  delegate :first_name, :last_name, :street, :zip_code, :city, :phone, :email, to: :seller, prefix: true
  delegate :name, :max_reservations, :max_items_per_reservation, to: :event, prefix: true
  delegate :number, to: :reservation, prefix: true

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

  def results_url
    urls[:results]
  end

  def review_url
    urls[:review]
  end

  def reserve_url
    urls[:reserve]
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

  def urls
    @data[:urls]
  end

  def l(text)
    ApplicationController.helpers.localize text
  end
end
