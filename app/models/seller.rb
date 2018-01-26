# frozen_string_literal: true

class Seller < ActiveRecord::Base
  acts_as_paranoid

  attr_accessor :accept_terms

  belongs_to :client

  has_many :reservations, dependent: :restrict_with_error
  has_many :notifications, dependent: :delete_all
  has_many :suspensions, dependent: :delete_all
  has_many :emails, dependent: :delete_all

  validates :client, :first_name, :last_name, :email, presence: true
  validates :street, :zip_code, :city, :phone, presence: { on: :update }
  validates :street, :zip_code, :city, :phone, presence: { on: :create }
  validates :accept_terms, acceptance: { on: :create }
  validates :email, uniqueness: { case_sensitive: false, scope: :client_id }
  validates_email_format_of :email
  validates :zip_code, format: { with: /\A\d{5}\z/, on: :update }
  validates :zip_code, format: { with: /\A\d{5}\z/, on: :create }
  validates :phone, format: { with: %r(\A\(?(\+ ?49|0)[ \(\)/\-\d]{5,30}[0-9]\z), on: :update }
  validates :phone, format: { with: %r(\A\(?(\+ ?49|0)[ \(\)/\-\d]{5,30}[0-9]\z), on: :create }

  scope :with_mailing, -> { where.has { mailing.eq true } }
  scope :active, -> { where.has { active.eq true } }
  scope :without_reservation_for, ->(event) { where.not(id: event.reservations.map(&:seller_id)) }
  scope :search, ->(needle) { needle.nil? ? all : where.has { sift :full_text_search, needle } }

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
end
