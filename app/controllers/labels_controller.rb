# frozen_string_literal: true

class LabelsController < ApplicationController
  before_action :set_vars

  def set_vars
    @seller = current_seller
    @event = Event.find params[:event_id]
    @reservation = Reservation.find params[:reservation_id]
  end

  def index
    @items = @reservation.items.order(:number)
  end

  def create
    selected_items = @reservation.items.where(id: params[:labels][:item])
    pdf = create_label_document(selected_items)
    send_data pdf, filename: 'etiketten.pdf', type: 'application/pdf'
  end
end
