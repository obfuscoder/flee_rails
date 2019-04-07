# frozen_string_literal: true

class ImportItem
  def initialize(item)
    @item = item
  end

  def call(reservation)
    raise StandardError if reservation.seller != @item.reservation.seller

    @reservation = reservation

    attributes = { category: @item.category,
                   description: @item.description,
                   size: @item.size,
                   price: @item.price,
                   donation: @item.donation }
    attributes[:code] = @item.code if copy_code?
    @reservation.items.create attributes
  end

  private

  def copy_code?
    @reservation.number == @item.reservation.number &&
      @reservation.event.client.import_item_code_enabled &&
      @reservation.items.find_by(code: @item.code).nil?
  end
end
