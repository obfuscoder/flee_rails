class Transaction < ApplicationRecord
  enum kind: { purchase: 0, refund: 1, checkin: 2, checkout: 3 }

  belongs_to :event
  has_many :transaction_items, dependent: :delete_all
  has_many :items, through: :transaction_items
  has_many :transaction_stock_items, dependent: :delete_all
  has_many :stock_items, through: :transaction_stock_items

  validates :event, presence: true
  validates :kind, presence: true
  validates :number, presence: true, uniqueness: { scope: :event_id }
end
