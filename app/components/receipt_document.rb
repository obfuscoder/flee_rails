class ReceiptDocument < PdfDocument
  def initialize(receipt)
    super()
    @receipt = receipt
  end

  def render
    header
    seller
    sold
    returned
    donated if @receipt.donation_enabled?
    super
  end

  private

  def sold
    section_headline @receipt.sold_items.length, 'verkauft'
    table sold_table_data, table_styles do |table|
      format_table(table)
      format_summary(table)
    end
    text "\n"
  end

  def returned
    table_section @receipt.returned_items, 'zurückgegeben', &method(:format_table)
  end

  def format_table(table)
    table.row(0).font_style = :bold
    table.column(-1).align = :right
  end

  def format_summary(table)
    table.row(-1).font_style = :bold
    table.row(-4).font_style = :bold
    table.row(-1).border_width = 3
  end

  def donated
    table_section @receipt.donated_items, 'gespendet', &method(:format_table)
  end

  def table_section(item_collection, action)
    section_headline item_collection.length, action
    unless item_collection.empty?
      table table_data(item_collection), table_styles do |table|
        yield table if block_given?
      end
    end
    text "\n"
  end

  def section_headline(count, action)
    text "#{count} Artikel wurde(n) #{action}", style: :bold
  end

  def table_data(item_collection)
    header_columns + item_collection.map do |item|
      [item.number, item.category.name, item.description, currency(item.price)]
    end
  end

  def sold_table_data
    table_data = header_columns
    table_data += @receipt.sold_items.map do |item|
      [item.number, item.category.name, item.description, currency(item.price)]
    end
    table_data << [{ content: 'Summe', colspan: 3 }, currency(@receipt.sold_items_sum)]
    table_data << [{ content: 'Kommissionsanteil', colspan: 3 }, currency(@receipt.commission_cut)]
    unless @receipt.event.reservation_fees_payed_in_advance
      table_data << [{ content: 'Reservierungsgebühr', colspan: 3 }, currency(@receipt.seller_fee)]
    end
    table_data << [{ content: 'Auszuzahlender Betrag', colspan: 3 }, currency(@receipt.payout)]
  end

  def returned_table_data
    header_columns + @receipt.returned_items.map do |item|
      [item.number, item.category.name, item.description, currency(item.price)]
    end
  end

  def donated_table_data
    header_columns + @receipt.donated_items.map do |item|
      [item.number, item.category.name, item.description, currency(item.price)]
    end
  end

  def header_columns
    [%w[Nr. Kategorie Beschreibung Preis]]
  end

  def table_styles
    { header: true, width: bounds.width, column_widths: column_widths, cell_style: { size: 10 } }
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

  def column_widths
    [bounds.width * 0.05, bounds.width * 0.3, bounds.width * 0.5, bounds.width * 0.15]
  end

  def currency(value)
    ActionController::Base.helpers.number_to_currency value
  end
end
