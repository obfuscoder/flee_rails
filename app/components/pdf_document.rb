# frozen_string_literal: true

class PdfDocument < Prawn::Document
  def initialize
    super page_size: 'A4'
    font_families.update 'freesans' => {
      normal: 'lib/assets/ttf/FreeSans.ttf',
      bold: 'lib/assets/ttf/FreeSansBold.ttf',
      italic: 'lib/assets/ttf/FreeSansOblique.ttf',
      bold_italic: 'lib/assets/ttf/FreeSansBoldOblique.ttf'
    }
    font 'freesans'
  end
end
