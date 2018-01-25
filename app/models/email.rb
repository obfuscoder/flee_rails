# frozen_string_literal: true

class Email < ActiveRecord::Base
  belongs_to :seller, -> { with_deleted }

  validates_presence_of :subject, :body, :seller, :kind
  validates_uniqueness_of :message_id, allow_nil: true
end
