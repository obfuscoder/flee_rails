require 'label_document'

class LabelsController < ApplicationController
  def index
    @reservation = current_seller.reservations.first
    @items = current_seller.items
  end

  def create
    pdf = LabelDocument.new current_seller.reservations.first.reserved_item
    send_data pdf.render, filename: 'etiketten.pdf', type: 'application/pdf'
  end
end
