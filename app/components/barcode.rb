module Barcode
  def barcode_cell(label)
    cell_top = bounds.top - header_line_height - small_line_height * 3
    cell_height = bounds.height - (bounds.top - cell_top)
    bounding_box [bounds.left, cell_top], width: bounds.width, height: cell_height do
      stroke_bounds
      barcode label
    end
  end

  def barcode(label)
    barcode = Barby::Code128.new label.code
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
        text label.code, align: :center, valign: :center, overflow: :shrink_to_fit, character_spacing: 2
      end
    end
  end
end
