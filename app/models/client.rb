# frozen_string_literal: true

class Client < ActiveRecord::Base
  has_many :events, dependent: :delete_all
  has_many :categories, dependent: :delete_all
  has_many :sellers, dependent: :delete_all
  has_many :stock_items, dependent: :delete_all
  has_many :users, dependent: :delete_all
  has_many :message_templates, dependent: :delete_all
  has_many :reservations, through: :events

  validates :key, uniqueness: { case_sensitive: false }, presence: true
  validates :prefix, uniqueness: true
  validates :terms, presence: true
  validates :name, presence: true
  validates :auto_reservation_numbers_start, numericality: { greater_than: 0, less_than_or_equal_to: 700, allow_nil: true }

  def host_match?(host)
    host.ends_with?(domain)
  end

  def mail_from
    "#{name} <#{mail_address}>"
  end

  def short_name
    self[:short_name].presence || name
  end

  def mail_address
    self[:mail_address] || "#{key}@#{Settings.domain}"
  end

  def url
    "https://#{domain}"
  end

  def destroy_everything!
    Transaction.joins(:event).where(events: { client_id: id }).destroy_all
    Seller.destroy_everything!(self)
    Message.joins(:event).where(events: { client_id: id }).destroy_all
    Rental.joins(:event).where(events: { client_id: id }).destroy_all
    SoldStockItem.joins(:stock_item).where(stock_items: { client_id: id }).destroy_all
    TimePeriod.joins(:event).where(events: { client_id: id }).destroy_all
    SupportType.joins(:event).where(events: { client_id: id }).destroy_all
    Size.joins(:category).where(categories: { client_id: id }).destroy_all
    destroy!
  end

  def reservation_by_seller_allowed?
    !reservation_by_seller_forbidden
  end

  def domain
    "#{key}.#{Settings.domain}"
  end
end
