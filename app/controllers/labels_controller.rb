require 'label_document'

class LabelsController < ApplicationController
  def index
    @reservation = current_seller.reservations.first
    @items = current_seller.items
  end

  def create
    reservation = current_seller.reservations.first
    selected_items = current_seller.items
    if params[:labels][:selection] != 'all'
      selected_items = selected_items.where(id: params[:labels][:item])
    end
    selected_items.without_label.each do |item|
      Label.create!(reservation: reservation, item: item)
    end
    pdf = LabelDocument.new(label_decorators(reservation.labels.where(item: selected_items)))
    send_data pdf.render, filename: 'etiketten.pdf', type: 'application/pdf'
  end

  def label_decorators(labels)
    labels.map do |label|
      {
        number: label.to_s,
        price: view_context.number_to_currency(label.item.price),
        details: "#{label.item.category}\n#{label.item}" +
          (label.item.size ? "\nGröße: #{label.item.size}" : ''),
        code: label.code
      }
    end
  end
end
