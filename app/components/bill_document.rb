# frozen_string_literal: true

class BillDocument < PdfDocument
  def initialize(bill)
    super
    @bill = bill
  end

  def render
    super
  end
end
