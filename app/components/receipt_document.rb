Prawn::Font::AFM.hide_m17n_warning = true

class ReceiptDocument < Prawn::Document
  def initialize(receipt)
    super page_size: 'A4'
    @receipt = receipt
  end

  def render
    header
    seller
    sold
    super
  end

  def sold
    text "#{@receipt.sold_items.length} Artikel wurde(n) verkauft", style: :bold
    table sold_table_data, header: true,
          width: bounds.width,
          column_widths: [bounds.width * 0.05, bounds.width * 0.3, bounds.width * 0.5, bounds.width * 0.15],
          cell_style: {size: 10} do |table|
      table.row(0).font_style = :bold
      table.row(-4).font_style = :bold
      table.row(-1).font_style = :bold
      table.column(-1).align = :right
      table.row(-1).border_width = 3
    end
  end

  def sold_table_data
    table_data = [['Nr.', 'Kategorie', 'Beschreibung', 'Preis']]
    table_data += @receipt.sold_items.map { |item| [item.number, item.category.name, item.description, c(item.price)] }
    table_data << [{content: 'Summe', colspan: 3}, c(@receipt.sold_items_sum)]
    table_data << [{content: 'Kommissionsanteil', colspan: 3}, c(@receipt.commission_cut)]
    table_data << [{content: 'Reservierungsgebühr', colspan: 3}, c(@receipt.seller_fee)]
    table_data << [{content: 'Auszuzahlender Betrag', colspan: 3}, c(@receipt.payout)]
  end

  def seller
    text @receipt.seller.name
    text @receipt.seller.street
    text "#{@receipt.seller.zip_code} #{@receipt.seller.city}"
    text "Reservierungsnummer: #{@receipt.reservation.number}", style: :bold
    text "\n"
  end

  def header
    text 'Abrechnung Flohmarkt', style: :bold, size: 18
    text @receipt.event.name, style: :bold
    text @receipt.date, size: 10
    text "\n"
  end

  private

  def c(value)
    ActionController::Base.helpers.number_to_currency value
  end
end