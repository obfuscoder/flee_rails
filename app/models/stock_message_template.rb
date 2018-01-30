# frozen_string_literal: true

class StockMessageTemplate < ActiveRecord::Base
  validates :category, uniqueness: true, presence: true
  validates :subject, presence: true
  validates :body, presence: true
end
