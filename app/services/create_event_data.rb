# frozen_string_literal: true

class CreateEventData
  def initialize(client)
    @client = client
  end

  def call(event)
    @event = event
    data = Jbuilder.new do |json|
      json.call @event, :id, :number, :name, :token, :price_precision, :commission_rate, :reservation_fee,
                :donation_of_unsold_items_enabled, :reservation_fees_payed_in_advance
      json.categories @client.categories.all, :id, :name
      json.stock_items @client.stock_items.all do |stock_item|
        json.description stock_item.description
        json.price stock_item.price
        json.number stock_item.number
        json.code stock_item.code
        json.sold stock_item.sold_stock_items.find_by(event: @event).try(:amount)
      end
      json.sellers @event.reservations.map(&:seller),
                   :id, :first_name, :last_name, :street, :zip_code, :city, :email, :phone
      json.reservations @event.reservations, :id, :number, :seller_id, :fee, :commission_rate
      json.items @event.reservations.map(&:items).flatten.reject { |item| item.code.nil? },
                 :id, :category_id, :reservation_id, :description, :size, :price,
                 :number, :code, :sold,
                 :donation, :gender
    end.target!
    ActiveSupport::Gzip.compress data
  end
end
