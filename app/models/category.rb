class Category < ActiveRecord::Base
  extend ActiveModel::Translation

  has_many :items, dependent: :destroy

  validates :name, presence: true, uniqueness: true
  validates :max_items_per_seller, numericality: { only_integer: true, allow_blank: true }

  scope :search, ->(needle) { needle.nil? ? all : where { sift :full_text_search, needle } }

  def to_s
    name || super
  end

  sifter :full_text_search do |needle|
    pattern = "%#{needle}%"
    name.matches(pattern)
  end
end
