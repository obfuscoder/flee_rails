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
    current_reservation = nil
    cell = [0, 0]
    @labels.each do |label|
      if current_reservation != label.reservation
        if current_reservation
          cell = [0, 0]
          start_new_page
        end
        current_reservation = label.reservation
      end
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
      details_next_to_donation(height, label, top)
    elsif label.gender?
      boxed_text(label.details, top, bounds.left, height, bounds.width * 4 / 5)
      gender_cell(label.gender, height, top)
    else
      boxed_text(label.details, top, bounds.left, height, bounds.width)
    end
  end

  FONT_NAME = 'freesans'

  def donation_cell(height, top)
    font FONT_NAME, style: :bold, size: 30 do
      boxed_text('S', top, bounds.left, height, bounds.width / 5)
    end
  end

  def gender_cell(gender, height, top)
    current_line_width = line_width
    self.line_width = 3
    center_point = [bounds.right - bounds.width / 5 / 2, top - height / 2]
    width = bounds.width / 5
    radius = [height, width].min * 0.2
    stroke do
      circle center_point, radius

      female_part(center_point, radius) if %i[female both].include? gender
      male_part(center_point, radius) if %i[male both].include? gender
    end
    self.line_width = current_line_width
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
    font FONT_NAME, style: :bold, size: 20 do
      number_header_cell label
      price_header_cell label
    end
  end

  def price_header_cell(label)
    boxed_text(label.price, bounds.top, bounds.left + bounds.width / 2, header_line_height, bounds.width / 2)
  end

  def number_header_cell(label)
    if label.reservation.present?
      boxed_text(label.reservation, bounds.top, bounds.left, header_line_height, bounds.width / 4)
      font FONT_NAME, style: :normal do
        boxed_text(label.number, bounds.top, bounds.left + bounds.width / 4, header_line_height, bounds.width / 4)
      end
    else
      boxed_text(label.number, bounds.top, bounds.left, header_line_height, bounds.width / 2)
    end
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

  private

  def details_next_to_donation(height, label, top)
    if label.gender?
      boxed_text(label.details, top, bounds.left + bounds.width / 5, height, bounds.width * 3 / 5)
      gender_cell(label.gender, height, top)
    else
      boxed_text(label.details, top, bounds.left + bounds.width / 5, height, bounds.width * 4 / 5)
    end
  end

  def female_part(center_point, radius)
    vertical_line center_point.second - radius, center_point.second - radius * 2.7, at: center_point.first
    horizontal_line center_point.first - radius * 0.7, center_point.first + radius * 0.7,
                    at: center_point.second - radius * 1.9
  end

  def male_part(center_point, radius)
    width = 0.7
    length = 1.8

    left = center_point.first + radius * width
    bottom = center_point.second + radius * width
    right = center_point.first + radius * length
    top = center_point.second + radius * length

    line [left, bottom], [right, top]
    move_to [left, top]
    line_to [right, top]
    line_to [right, bottom]
  end
end
