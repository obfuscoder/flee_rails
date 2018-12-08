# frozen_string_literal: true

class Supporter < ActiveRecord::Base
  belongs_to :support_type
  belongs_to :seller
  validates :seller, presence: true, uniqueness: { scope: :support_type_id }

  def self.search(needle)
    return all if needle.nil?

    joins(:seller).where.has { sift(:full_text_search, needle) | seller.sift(:full_text_search, needle) }
  end

  sifter :full_text_search do |needle|
    pattern = "%#{needle}%"
    comments.matches(pattern)
  end
end
