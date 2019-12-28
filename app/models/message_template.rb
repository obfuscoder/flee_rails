class MessageTemplate < ApplicationRecord
  belongs_to :client

  validates :category, uniqueness: { scope: :client_id }, presence: true
  validates :subject, presence: true
  validates :body, presence: true
end
