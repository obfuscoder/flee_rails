# frozen_string_literal: true

class LabelsController < ApplicationController
  before_action :set_vars

  def set_vars
    @seller = current_seller
    @event = current_client.events.find params[:event_id]
    @reservation = @event.reservations.find params[:reservation_id]
  end

  def index
    @items = @reservation.items.order(:number)
  end

  def create
    return redirect_to event_reservation_labels_path(@event, @reservation) if params[:labels].nil?

    selected_items = @reservation.items.where(id: params[:labels][:item])
    pdf = CreateLabelDocument.new(current_client, selected_items).call
    send_data pdf, filename: 'etiketten.pdf', type: 'application/pdf'
  end
end
