# frozen_string_literal: true

class CreateReceiptDocument
  def initialize(reservation)
    @reservation = reservation
  end

  def call
    ReceiptDocument.new(Receipt.new(@reservation)).render
  end
end
