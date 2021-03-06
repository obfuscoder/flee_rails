class LabelDecorator
  def initialize(item)
    @item = item
  end

  def reservation
    @item.reservation.number.to_s
  end

  def number
    @item.number.to_s
  end

  def price
    ActionController::Base.helpers.number_to_currency(@item.price)
  end

  def details
    "#{@item.category}\n#{@item.description}" + (@item.size.blank? ? '' : "\n<strong>Größe: #{@item.size}</strong>")
  end

  def code
    @item.code
  end

  def donation?
    @item.donation?
  end

  def gender?
    @item.category.gender?
  end

  def gender
    return nil unless gender? && @item.gender

    @item.gender.to_sym
  end
end
