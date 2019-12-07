# frozen_string_literal: true

class BillDocument < PdfDocument
  def initialize(bill)
    super()
    @bill = bill
  end

  def render
    render_title
    move_down 50
    text @bill.address
    move_down 50
    render_header
    move_down 30
    render_prefix
    move_down 30
    items_table
    move_down 30
    render_postfix
    render_footer
    render_logo
    super
  end

  private

  def render_prefix
    text 'Wir bedanken uns für die gute Zusammenarbeit und stellen Ihnen hiermit ' \
         'vereinbarungsgemäß folgende Lieferungen und Leistungen in Rechnung:'
  end

  def render_postfix
    text 'Bitte überweisen Sie den Betrag innerhalb von 30 Tagen auf das unten ' \
         'angegebene Konto unter Angabe der Rechnungsnummer.'
    move_down 20
    text 'Mit freundlichen Grüßen,'
    move_down 10
    text Settings.bill.issuer.name
    text Settings.bill.issuer.company
  end

  def render_logo
    logo = Rails.root.join 'app/assets/images/logo.png'
    image logo, at: [340, 800], scale: 0.5
  end

  def render_footer
    move_cursor_to 60
    text "Web: #{Settings.bill.issuer.web}", size: 10
    text "Mail: #{Settings.bill.issuer.email}", size: 10
    text "Tel.: #{Settings.bill.issuer.phone}", size: 10
    text "Bank: #{Settings.bill.issuer.bank}", size: 10
  end

  def render_header
    text "Leistungsdatum: #{date(@bill.delivery_date)}"
    text "Rechnungsdatum: #{date(@bill.date)}"
    move_down 50
    text "Rechnung Nr. #{@bill.number}", size: 16, style: :bold
    text '(Bitte bei Fragen und Überweisungen mit angeben)', size: 10
  end

  def render_title
    text Settings.bill.title, size: 20, style: :bold
    text Settings.bill.issuer.address.join(', '), size: 10
  end

  def items_table
    table items_table_data, table_styles do |table|
      format_table table
    end
  end

  def date(value)
    value.strftime '%d. %m. %Y'
  end

  def table_styles
    { header: true, width: bounds.width, column_widths: column_widths, cell_style: { borders: [] } }
  end

  def format_table(table)
    table.row(0).font_style = :bold
    table.column(2..4).align = :right
    table.row(-1).font_style = :bold
    table.row(0).borders = [:bottom]
  end

  def items_table_data
    table_data = [header_columns]
    table_data += @bill.items.each_with_index.map do |item, index|
      [index + 1, item.description, currency(item.price), item.amount, currency(item.sum)]
    end
    table_data << ['', { content: 'Summe', colspan: 3 }, currency(@bill.total)]
  end

  def header_columns
    %w[Nr. Beschreibung Preis Anzahl Summe]
  end

  def currency(value)
    ActionController::Base.helpers.number_to_currency value
  end

  def column_widths
    [bounds.width * 0.05, bounds.width * 0.5, bounds.width * 0.15, bounds.width * 0.15]
  end
end
