class Contact
  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming

  attr_accessor :topic, :body, :email, :name, :seller, :client, :add1, :add2, :sum

  validates :topic, :body, presence: true
  validates :email, :name, presence: true, unless: :seller?
  validates_email_format_of :email, unless: :seller?
  validate :correct_sum

  def initialize(attributes = {})
    self.add1 = rand(2..12)
    self.add2 = rand(2..12)
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

  def correct_sum
    errors.add(:sum) unless sum.to_i == add1.to_i + add2.to_i
  end
end
