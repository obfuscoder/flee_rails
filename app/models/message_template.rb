# frozen_string_literal: true

class MessageTemplate < ActiveRecord::Base
  belongs_to :client

  validates :category, uniqueness: { scope: :client_id }, presence: true
  validates :subject, presence: true
  validates :body, presence: true
end
