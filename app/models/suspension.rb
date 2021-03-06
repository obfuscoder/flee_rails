class Suspension < ApplicationRecord
  belongs_to :event
  belongs_to :seller, -> { with_deleted }, inverse_of: :suspensions

  validates :seller, :event, :reason, presence: true
  validates :seller_id, uniqueness: { scope: :event_id }

  def self.search(needle)
    return all if needle.blank?

    joins(:seller).where.has { sift(:full_text_search, needle) | seller.sift(:full_text_search, needle) }
  end

  sifter :full_text_search do |needle|
    pattern = "%#{needle}%"
    reason.matches pattern
  end
end
