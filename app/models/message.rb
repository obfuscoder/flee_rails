# frozen_string_literal: true

class Message < ActiveRecord::Base
  belongs_to :event
  validates :category, uniqueness: { scope: :event_id }

  def sent_count
    self[:sent_count] ||= 0
  end

  def sent
    update sent_count: sent_count + 1
  end
end
