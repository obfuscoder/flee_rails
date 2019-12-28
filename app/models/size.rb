class Size < ApplicationRecord
  belongs_to :category, -> { with_deleted }, inverse_of: :sizes

  validates :value, presence: true, length: { maximum: 50 }, uniqueness: { scope: :category_id }

  def to_s
    value
  end
end
