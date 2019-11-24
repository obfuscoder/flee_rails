# frozen_string_literal: true

class Email < ApplicationRecord
  belongs_to :seller, -> { with_deleted }, inverse_of: :emails

  validates :subject, :body, :seller, :kind, presence: true
  validates :message_id, uniqueness: { allow_nil: true }
end
