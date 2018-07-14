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
  validates :domain, uniqueness: { case_sensitive: false }
  validates :terms, presence: true
  validates :name, presence: true

  def host_match?(host)
    host.ends_with?(domain) || host.ends_with?(key_based_domain)
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

  def domain
    self[:domain] || key_based_domain
  end

  def url
    "http://#{domain}"
  end

  def destroy_everything!
    Transaction.joins(:event).where(events: { client_id: id }).destroy_all
    Seller.destroy_everything!(self)
    Message.joins(:event).where(events: { client_id: id }).destroy_all
    Rental.joins(:event).where(events: { client_id: id }).destroy_all
    SoldStockItem.joins(:stock_item).where(stock_items: { client_id: id }).destroy_all
    TimePeriod.joins(:event).where(events: { client_id: id }).destroy_all
    SupportType.joins(:event).where(events: { client_id: id }).destroy_all
    destroy!
  end

  private

  def key_based_domain
    "#{key}.#{Settings.domain}"
  end
end
