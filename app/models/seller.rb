class Seller < ApplicationRecord
  acts_as_paranoid

  attr_accessor :accept_terms

  belongs_to :client

  # !! we must not specify dependent option as it would delete reservations/supports associations on soft delete
  # we should move away from 'paranoid' to 'paper_trail' or 'discard' to fix this
  has_many :reservations
  has_many :notifications, dependent: :delete_all
  has_many :suspensions, dependent: :delete_all
  has_many :emails, dependent: :delete_all
  has_many :supporters

  validates :client, :email, presence: true
  validates :first_name, :last_name, :street, :zip_code, :city, :phone, presence: { on: :update }
  validates :first_name, :last_name, :street, :zip_code, :city, :phone, presence: { on: :create }
  validates :accept_terms, acceptance: { on: :create }
  validates :default_reservation_number, uniqueness: { scope: :client_id, allow_nil: true }
  validates :default_reservation_number, numericality: { greater_than: 0, less_than: 1000, allow_nil: true }

  validates :email, uniqueness: { case_sensitive: false, scope: :client_id, on: :create }
  validates :email, uniqueness: { case_sensitive: false, scope: :client_id, on: :update }
  validates_email_format_of :email
  validates :zip_code, format: { with: /\A\d{5}\z/, on: :update }
  validates :zip_code, format: { with: /\A\d{5}\z/, on: :create }
  validates :phone, format: { with: %r(\A\(?(\+ ?49|0)[ \(\)/\-\d]{5,30}[0-9]\z), on: :update }
  validates :phone, format: { with: %r(\A\(?(\+ ?49|0)[ \(\)/\-\d]{5,30}[0-9]\z), on: :create }

  validate :email_exists, on: :resend_activation
  validate :default_reservation_number_in_range

  scope :with_mailing, -> { where.has { mailing.eq true } }
  scope :active, -> { where.has { active.eq true } }
  scope :without_reservation_for, ->(event) { where.not(id: event.reservations.map(&:seller_id)) }
  scope :search, ->(needle) { needle.nil? ? all : where.has { sift :full_text_search, needle } }
  scope :available_for_support_type, ->(support_type) { where.not(id: support_type.supporters.map(&:seller_id)) }

  include Statistics

  before_validation do
    email&.downcase!
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

  def label_for_selects
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

  def suspended_for?(event)
    suspensions.find_by(event: event).present?
  end

  def self.destroy_everything!(client)
    Seller.unscoped { Email.joins(:seller).where(sellers: { client_id: client.id }).destroy_all }
    Item.joins(reservation: :seller).where(sellers: { client_id: client.id }).destroy_all
    Review.joins(reservation: :seller).where(sellers: { client_id: client.id }).destroy_all
    Reservation.joins(:seller).where(sellers: { client_id: client.id }).destroy_all
    Notification.joins(:seller).where(sellers: { client_id: client.id }).destroy_all
    Suspension.joins(:seller).where(sellers: { client_id: client.id }).destroy_all
    Supporter.joins(:seller).where(sellers: { client_id: client.id }).destroy_all
    Seller.unscoped.where(client_id: client.id).delete_all
  end

  private

  def paranoia_destroy_attributes
    {
      deleted_at: current_time_from_proper_timezone,
      active: nil, mailing: nil,
      first_name: nil, last_name: nil,
      phone: nil, email: nil,
      street: nil,
      city: nil,
      token: nil
    }
  end

  def email_exists
    return if Seller.exists? email: email, client: client

    errors.add :email, :unknown
  end

  def default_reservation_number_in_range
    return if default_reservation_number.nil? || client.nil?

    auto_start = client.auto_reservation_numbers_start || 1
    return if default_reservation_number < auto_start

    errors.add :default_reservation_number, :out_of_range
  end
end
