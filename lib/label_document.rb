require 'barby/barcode/code_128'
require 'barby/outputter/prawn_outputter'

class LabelDocument < Prawn::Document
  COLS = 3
  ROWS = 6

  def initialize(labels)
    super page_size: 'A4'
    define_grid columns: COLS, rows: ROWS
    @labels = labels
  end

  def render
    cell = [0, 0]
    @labels.each do |_label|
      label_cell(cell)
      cell = next_cell(cell)
    end
    super
  end

  def label_cell(cell)
    grid(cell).bounding_box do
      header_cells
      category_cell
      description_cell
      size_cell
      barcode_cell
    end
  end

  def barcode_cell
    barcode_top = bounds.top - header_line_height - small_line_height * 3
    height = bounds.height - (bounds.top - barcode_top)
    bounding_box [bounds.left, barcode_top], width: bounds.width, height: height do
      barcode = Barby::Code128B.new 'AaZ040090015'
      outputter = Barby::PrawnOutputter.new barcode
      height = bounds.height * 0.6
      horizontal_offset = (bounds.width - outputter.full_width) / 2
      vertical_offset = (bounds.height - height) / 2
      outputter.annotate_pdf self, height: height, x: horizontal_offset, y: vertical_offset
    end
  end

  def small_line_height
    bounds.height / 8
  end

  def header_line_height
    bounds.height / 4
  end

  def bounding_box(pt, *args, &block)
    super(pt, args) do
      stroke_bounds
      yield block
    end
  end

  def size_cell
    top_offset = bounds.top - header_line_height - small_line_height * 2
    bounding_box [bounds.left, top_offset], width: bounds.width, height: small_line_height do
      text 'Größe', align: :center, valign: :center
    end
  end

  def description_cell
    top_offset = bounds.top - header_line_height - small_line_height
    bounding_box [bounds.left, top_offset], width: bounds.width, height: small_line_height do
      text 'Beschreibung', align: :center, valign: :center
    end
  end

  def category_cell
    top_offset = bounds.top - header_line_height
    bounding_box [bounds.left, top_offset], width: bounds.width, height: small_line_height do
      text 'Kategorie', align: :center, valign: :center
    end
  end

  def header_cells
    font 'Helvetica', style: :bold do
      number_header_cell
      price_header_cell
    end
  end

  def price_header_cell
    bounding_box [bounds.left + bounds.width / 2, bounds.top], width: bounds.width / 2, height: header_line_height do
      text '999,99 €', align: :center, valign: :center, size: 20
    end
  end

  def number_header_cell
    bounding_box bounds.top_left, width: bounds.width / 2, height: header_line_height do
      text '999-999', align: :center, valign: :center, size: 20
    end
  end

  def next_cell(cell)
    col, row = cell
    col += 1
    if col == COLS
      col = 0
      row = next_row(row)
    end
    [col, row]
  end

  def next_row(row)
    row += 1
    if row == ROWS
      row = 0
      start_new_page
    end
    row
  end
end
