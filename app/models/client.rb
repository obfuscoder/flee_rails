# frozen_string_literal: true

class Client < ActiveRecord::Base
  has_many :events
  has_many :categories
  has_many :sellers
  has_many :stock_items
  has_many :users

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
    self[:short_name] || name
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

  private

  def key_based_domain
    "#{key}.#{Settings.domain}"
  end
end
