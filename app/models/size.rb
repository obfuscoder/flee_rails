class Size < ActiveRecord::Base
  belongs_to :category, -> { with_deleted }, inverse_of: :sizes
  validates :value, presence: true, uniqueness: { scope: :category_id }

  def to_s
    value
  end
end
