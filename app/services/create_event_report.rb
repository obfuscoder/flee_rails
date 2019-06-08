# frozen_string_literal: true

class CreateEventReport
  def initialize(event)
    @event = event
  end

  def call
    items = @event.items.map do |item|
      [
        item.reservation.number,
        item.number,
        item.category.name,
        item.description,
        item.size,
        I18n.t('gender.' + item.gender),
        item.price].join("\t")
    end
    header = %w[Reservierungsnummer Artikelnummer Kategorie Beschreibung Größe Geschlecht Preis].join("\t")
    ([header] + items).join("\n")
  end
end
