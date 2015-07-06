require 'barby/barcode/code_128'
require 'barby/outputter/prawn_outputter'
Prawn::Font::AFM.hide_m17n_warning = true

class LabelDocument < Prawn::Document
  COLS = 3
  ROWS = 6

  def initialize(labels, options = {})
    super page_size: 'A4'
    @labels = labels
    @with_donation = options.extract!(:with_donation).values.first
  end

  def render
    define_grid columns: COLS, rows: ROWS, gutter: 5
    cell = [0, 0]
    @labels.each do |label|
      label_cell(cell, label)
      cell = next_cell(cell)
      start_new_page if cell == [0, 0]
    end
    super
  end

  def label_cell(cell, label)
    grid(cell[1], cell[0]).bounding_box do
      stroke_bounds
      header_cells label
      details_cell label
      barcode_cell label
    end
  end

  def barcode_cell(label)
    cell_top = bounds.top - header_line_height - small_line_height * 3
    cell_height = bounds.height - (bounds.top - cell_top)
    bounding_box [bounds.left, cell_top], width: bounds.width, height: cell_height do
      stroke_bounds
      barcode label
    end
  end

  def barcode(label)
    barcode = Barby::Code128.new label[:code]
    outputter = Barby::PrawnOutputter.new(barcode)
    barcode_height = bounds.height / 2
    horizontal_offset = (bounds.width - outputter.full_width) / 2
    vertical_offset = barcode_height * 2 / 3
    outputter.annotate_pdf self, height: barcode_height, x: horizontal_offset, y: vertical_offset
    barcode_text label, vertical_offset, horizontal_offset, vertical_offset, outputter.full_width
  end

  def barcode_text(label, top, left, height, width)
    bounding_box [left, top], width: width, height: height do
      font 'Courier', size: 10 do
        text label[:code], align: :center, valign: :center, overflow: :shrink_to_fit, character_spacing: 2
      end
    end
  end

  def small_line_height
    bounds.height / 8
  end

  def header_line_height
    bounds.height / 4
  end

  def details_cell(label)
    top = bounds.top - header_line_height
    height = small_line_height * 3
    if @with_donation && label[:donation]
      donation_cell(height, top)
      boxed_text(label[:details], top, bounds.left + bounds.width / 5, height, bounds.width * 4 / 5)
    else
      boxed_text(label[:details], top, bounds.left, height, bounds.width)
    end
  end

  def donation_cell(height, top)
    font 'Helvetica', style: :bold, size: 30 do
      boxed_text('S', top, bounds.left, height, bounds.width / 5)
    end
  end

  def boxed_text(text, top, left, height, width)
    bounding_box [left, top], width: width, height: height do
      stroke_bounds
      center_text text
    end
  end

  def center_text(text)
    text_box text, align: :center, valign: :center, overflow: :shrink_to_fit
  end

  def header_cells(label)
    font 'Helvetica', style: :bold, size: 20 do
      number_header_cell label
      price_header_cell label
    end
  end

  def price_header_cell(label)
    boxed_text(label[:price], bounds.top, bounds.left + bounds.width / 2, header_line_height, bounds.width / 2)
  end

  def number_header_cell(label)
    boxed_text(label[:number], bounds.top, bounds.left, header_line_height, bounds.width / 2)
  end

  def next_cell(cell)
    col, row = cell
    col = (col + 1) % COLS
    row = next_row(row) if col == 0
    [col, row]
  end

  def next_row(row)
    (row + 1) % ROWS
  end
end
