# frozen_string_literal: true

class Suspension < ActiveRecord::Base
  belongs_to :event
  belongs_to :seller

  validates_presence_of :seller, :event, :reason
  validates :seller_id, uniqueness: { scope: :event_id }

  def self.search(needle)
    return all unless needle.present?
    joins(:seller).where.has { sift(:full_text_search, needle) | seller.sift(:full_text_search, needle) }
  end

  sifter :full_text_search do |needle|
    pattern = "%#{needle}%"
    reason.matches pattern
  end
end
