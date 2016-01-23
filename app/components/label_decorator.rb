class LabelDecorator
  def initialize(item)
    @item = item
  end

  def number
    "#{@item.reservation.number} - #{@item.number}"
  end

  def price
    ActionController::Base.helpers.number_to_currency(@item.price)
  end

  def details
    "#{@item.category}\n#{@item.description}" + (@item.size.blank? ? '' : "\nGröße: #{@item.size}")
  end

  def code
    @item.code
  end

  def donation?
    @item.donation?
  end
end
