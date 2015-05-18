require 'label_document'

class LabelsController < ApplicationController
  def index
    @reservation = current_seller.reservations.first
    @items = current_seller.items
  end

  def create
    reservation = current_seller.reservations.first
    current_seller.items.without_label.each do |item|
      ReservedItem.create!(reservation: reservation, item: item)
    end
    pdf = LabelDocument.new(labels(reservation.reserved_items))
    send_data pdf.render, filename: 'etiketten.pdf', type: 'application/pdf'
  end

  def labels(reserved_items)
    reserved_items.map do |reserved_item|
      {
        number: reserved_item.to_s,
        price: view_context.number_to_currency(reserved_item.item.price),
        details: "#{reserved_item.item.category}\n#{reserved_item.item}" +
          (reserved_item.item.size ? "\nGröße: #{reserved_item.item.size}" : ''),
        code: reserved_item.code
      }
    end
  end
end
