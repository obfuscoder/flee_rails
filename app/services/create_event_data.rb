class CreateEventData
  def initialize(client)
    @client = client
  end

  def call(event)
    @event = event
    data = Jbuilder.new do |json|
      json.call @event, :id, :number, :name, :token, :price_precision, :precise_bill_amounts,
                :commission_rate, :reservation_fee, :price_factor,
                :donation_of_unsold_items_enabled, :reservation_fees_payed_in_advance, :gates,
                :reservation_fee_based_on_item_count
      json.categories @client.categories.all.with_deleted, :id, :name
      stock_items(json)
      json.sellers @event.reservations.order(:number).map(&:seller),
                   :id, :first_name, :last_name, :street, :zip_code, :city, :email, :phone
      json.reservations @event.reservations.order(:number), :id, :number, :seller_id, :fee, :commission_rate
      items(json)
    end.target!
    ActiveSupport::Gzip.compress data
  end

  private

  def stock_items(json)
    json.stock_items @client.stock_items.all do |stock_item|
      json.description stock_item.description
      json.price stock_item.price
      json.number stock_item.number
      json.code stock_item.code
      json.sold stock_item.sold_stock_items.find_by(event: @event).try(:amount)
    end
  end

  def items(json)
    json.items @event.reservations.order(:number).map(&:items).flatten.reject { |item| item.code.nil? },
               :id, :category_id, :reservation_id, :description, :size, :price,
               :number, :code, :sold,
               :donation, :gender,
               :checked_in, :checked_out
  end
end
