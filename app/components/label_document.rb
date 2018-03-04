# frozen_string_literal: true

require 'barby/barcode/code_128'
require 'barby/outputter/prawn_outputter'

class LabelDocument < PdfDocument
  include Barcode

  COLS = 3
  ROWS = 6

  def initialize(labels)
    super()
    @labels = labels
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

  def small_line_height
    bounds.height / 8
  end

  def header_line_height
    bounds.height / 4
  end

  def details_cell(label)
    top = bounds.top - header_line_height
    height = small_line_height * 3
    if label.donation?
      donation_cell(height, top)
      boxed_text(label.details, top, bounds.left + bounds.width / 5, height, bounds.width * 4 / 5)
    else
      boxed_text(label.details, top, bounds.left, height, bounds.width)
    end
  end

  def donation_cell(height, top)
    font 'freesans', style: :bold, size: 30 do
      boxed_text('S', top, bounds.left, height, bounds.width / 5)
    end
  end

  def boxed_text(text, top, left, height, width)
    bounding_box [left, top], width: width, height: height do
      stroke_bounds
      scale 0.9, origin: [width / 2, height / 2] do
        center_text text
      end
    end
  end

  def center_text(text)
    text_box text, align: :center, valign: :center, overflow: :shrink_to_fit, inline_format: true
  end

  def header_cells(label)
    font 'freesans', style: :bold, size: 20 do
      number_header_cell label
      price_header_cell label
    end
  end

  def price_header_cell(label)
    boxed_text(label.price, bounds.top, bounds.left + bounds.width / 2, header_line_height, bounds.width / 2)
  end

  def number_header_cell(label)
    boxed_text(label.number, bounds.top, bounds.left, header_line_height, bounds.width / 2)
  end

  def next_cell(cell)
    col, row = cell
    col = (col + 1) % COLS
    row = next_row(row) if col.zero?
    [col, row]
  end

  def next_row(row)
    (row + 1) % ROWS
  end
end
