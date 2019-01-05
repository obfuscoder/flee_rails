# frozen_string_literal: true

class Contact
  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming

  attr_accessor :topic, :body, :email, :name, :seller, :client

  validates :topic, :body, presence: true
  validates :email, :name, presence: true, unless: :seller?
  validates_email_format_of :email, unless: :seller?

  def initialize(attributes = {})
    attributes.each do |name, value|
      send("#{name}=", value)
    end
  end

  def persisted?
    false
  end

  def seller?
    seller.present?
  end

  def to_options
    options = { client: client, subject: topic, body: body }
    if seller.present?
      options.merge(seller: seller, name: seller.name, email: seller.email)
    else
      options.merge(name: name, email: email)
    end
  end
end
