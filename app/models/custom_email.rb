class CustomEmail
  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming

  attr_accessor :subject, :body, :sellers,
                :active,
                :reservation, :reservation_event,
                :notification, :notification_event,
                :items, :items_event

  validates :subject, :body, :sellers, presence: true

  def initialize(attributes = {})
    attributes.each do |name, value|
      send("#{name}=", value)
    end
  end

  def persisted?
    false
  end
end
