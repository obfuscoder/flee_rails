# frozen_string_literal: true

require 'barby/outputter/prawn_outputter'

class SupportTypesDocument < PdfDocument
  COLS = 2

  def initialize(event, support_types)
    super()
    @event = event
    @support_types = support_types
  end

  def render
    repeat :all, dynamic: true do
      draw_text "#{page_number}/#{page_count}", at: [500, 0]
    end

    text @event.name, size: 20
    move_down 20
    @support_types.each do |support_type|
      text support_type.name, size: 16
      move_down 10
      support_type.supporters.joins(:seller).merge(Seller.order(:first_name, :last_name)).each do |supporter|
        txt = supporter.seller.name
        txt += " (#{supporter.comments})" if supporter.comments.present?
        text txt
        move_down 10
      end
      move_down 10
    end
    super
  end
end
