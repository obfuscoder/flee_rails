class StockMessageTemplate < ApplicationRecord
  validates :category, uniqueness: true, presence: true
  validates :subject, presence: true
  validates :body, presence: true
end
