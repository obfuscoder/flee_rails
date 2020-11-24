class CreateEventReport
  def initialize(event)
    @event = event
  end

  def call
    items = @event.items.includes(:category, :reservation).map do |item|
      [
        item.reservation.number,
        item.number,
        item.category.name,
        item.description,
        item.size,
        item.gender.present? ? I18n.t("gender.#{item.gender}") : '',
        item.price,
        I18n.t(item.sold.present?)
      ].join("\t")
    end
    header = %w[Reservierungsnummer Artikelnummer Kategorie Beschreibung Größe Geschlecht Preis verkauft].join("\t")
    ([header] + items).join("\n")
  end
end
