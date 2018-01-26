# frozen_string_literal: true

class Email < ActiveRecord::Base
  belongs_to :seller, -> { with_deleted }

  validates :subject, :body, :seller, :kind, presence: true
  validates :message_id, uniqueness: { allow_nil: true }
end
