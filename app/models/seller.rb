class Seller < ActiveRecord::Base
  attr_accessor :accept_terms

  has_many :items, dependent: :destroy
  has_many :reservations, dependent: :destroy
  has_many :notifications, dependent: :destroy
  has_many :reviews, dependent: :destroy

  validates_presence_of :first_name, :last_name, :street, :zip_code, :city, :phone, :email
  validates_acceptance_of :accept_terms, on: :create
  validates_uniqueness_of :email, case_sensitive: false
  validates_email_format_of :email
  validates_format_of :zip_code, with: /\A\d{5}\z/
  validates_format_of :phone, with: %r(\A(\+ ?49|0)[ \(\)/\-\d]{5,30}[0-9]\z)

  scope :active, -> { where { active.eq true } }
  scope :without_reservation_for, ->(event) { where { id << event.reservations.map(&:seller_id) } }

  before_validation do
    email.try(:downcase!)
  end

  before_create do
    self.token = loop do
      random_token = SecureRandom.urlsafe_base64(nil, false)
      break random_token unless self.class.exists?(token: random_token)
    end
  end

  def to_s
    "#{first_name} #{last_name}"
  end

  alias_method :name, :to_s

  def label_for_reservation
    "#{name}, #{city} (#{email}) - #{items.count} Artikel"
  end
end
