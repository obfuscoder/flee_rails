require 'label_document'

class LabelsController < ApplicationController
  before_action :set_vars

  def set_vars
    @seller = current_seller
    @event = Event.find params[:event_id]
    @reservation = Reservation.find_by_event_id_and_seller_id @event.id, @seller.id
  end

  def index
    @items = @reservation.items
  end

  def create
    selected_items = @reservation.items.where(id: params[:labels][:item])
    selected_items.without_label.each do |item|
      item.create_code
      item.save!
    end
    pdf = LabelDocument.new(label_decorators(selected_items))
    send_data pdf.render, filename: 'etiketten.pdf', type: 'application/pdf'
  end

  def label_decorators(items)
    items.map do |item|
      {
        number: "#{item.reservation.number} - #{item.number}",
        price: view_context.number_to_currency(item.price),
        details: "#{item.category}\n#{item.description}" +
          (item.size ? "\nGröße: #{item.size}" : ''),
        code: item.code
      }
    end
  end
end
