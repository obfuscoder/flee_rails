# frozen_string_literal: true

class StockLabelDecorator
  def initialize(stock_item)
    @stock_item = stock_item
  end

  def number
    @stock_item.number.to_s
  end

  def price
    ActionController::Base.helpers.number_to_currency(@stock_item.price)
  end

  def details
    @stock_item.description
  end

  def code
    @stock_item.code
  end

  def donation?
    false
  end

  def reservation
    nil
  end
end
