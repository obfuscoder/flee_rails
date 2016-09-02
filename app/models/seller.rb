class Seller < ActiveRecord::Base
  attr_accessor :accept_terms

  has_many :reservations, dependent: :destroy
  has_many :notifications, dependent: :destroy
  has_many :reviews, dependent: :destroy

  validates_presence_of :first_name, :last_name, :email
  validates_presence_of :street, :zip_code, :city, :phone, on: :update
  validates_presence_of :street, :zip_code, :city, :phone, on: :create
  validates_acceptance_of :accept_terms, on: :create
  validates_uniqueness_of :email, case_sensitive: false
  validates_email_format_of :email
  validates_format_of :zip_code, with: /\A\d{5}\z/, on: :update
  validates_format_of :zip_code, with: /\A\d{5}\z/, on: :create
  validates_format_of :phone, with: %r(\A\(?(\+ ?49|0)[ \(\)/\-\d]{5,30}[0-9]\z), on: :update
  validates_format_of :phone, with: %r(\A\(?(\+ ?49|0)[ \(\)/\-\d]{5,30}[0-9]\z), on: :create

  scope :with_mailing, -> { where { mailing.eq true } }
  scope :active, -> { where { active.eq true } }
  scope :without_reservation_for, ->(event) { where { id << event.reservations.map(&:seller_id) } }
  scope :search, ->(needle) { needle.nil? ? all : where { sift :full_text_search, needle } }

  include Statistics

  before_validation do
    email.try(:downcase!)
  end

  before_create do
    self.token ||= loop do
      random_token = SecureRandom.urlsafe_base64(nil, false)
      break random_token unless self.class.exists?(token: random_token)
    end
  end

  def to_s
    "#{first_name} #{last_name}"
  end

  alias name to_s

  def label_for_reservation
    "#{name}, #{city} (#{email})"
  end

  sifter :full_text_search do |needle|
    pattern = "%#{needle}%"
    first_name.matches(pattern) |
      last_name.matches(pattern) |
      street.matches(pattern) |
      zip_code.matches(pattern) |
      city.matches(pattern) |
      email.matches(pattern) |
      phone.matches(pattern)
  end
end
