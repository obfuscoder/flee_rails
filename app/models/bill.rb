class Bill < ApplicationRecord
  belongs_to :event

  validates :event, :number, :document, presence: true
  validates :number, uniqueness: true

  before_validation :create_number, :create_document

  def date
    (created_at || Date.today).to_date
  end

  def from_address
    Settings.imprint.address.join "\n"
  end

  def address
    event.client.invoice_address.strip
  end

  def delivery_date
    event.shopping_periods.last.max.to_date
  end

  def items
    result = [OpenStruct.new(description: 'Nutzungslizenzgebühr',
                             price: event.revenue,
                             amount: (event.number == 1 ? 0 : '1 %'),
                             sum: event.system_fees)]
    if event.number == 1
      result << OpenStruct.new(description: 'Einrichtungsgebühr',
                               price: setup_fee,
                               amount: 1,
                               sum: setup_fee)
    end
    event.rentals.each do |rental|
      result << OpenStruct.new(description: "Verleih #{rental.hardware.description}",
                               price: rental.hardware.price,
                               amount: rental.amount,
                               sum: rental.hardware.price * rental.amount)
    end
    result
  end

  def total
    event.number == 1 ? event.total_fees + setup_fee : event.total_fees
  end

  private

  def setup_fee
    50.0
  end

  def create_number
    return if event.nil? || number.present?

    date_part = date.strftime '%Y%m'
    max_number = Bill.maximum :number
    number_part = max_number&.start_with?(date_part) ? max_number[7..9].to_i + 1 : 1
    self.number = date_part + number_part.to_s.rjust(3, '0')
  end

  def create_document
    return if event.nil? || number.nil? || document.present?

    self.document = BillDocument.new(self).render
  end
end
