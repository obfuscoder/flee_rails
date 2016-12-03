class Category < ActiveRecord::Base
  extend ActiveModel::Translation

  acts_as_paranoid

  has_many :items
  has_many :children, class_name: Category, foreign_key: :parent_id, dependent: :restrict_with_error
  belongs_to :parent, class_name: Category

  validates :name, presence: true, uniqueness: true
  validates :max_items_per_seller, numericality: { only_integer: true, allow_blank: true }

  scope :search, ->(needle) { needle.nil? ? all : where { sift :full_text_search, needle } }

  def self.item_groups
    joins { items }.group(:name).select { [name, count(items.id).as(count)] }
                   .order { count(items.id).desc }
                   .map { |e| [e.name, e.count] }
  end

  def descendants
    children.collect(&:self_and_descendants).flatten
  end

  def self_and_descendants
    descendants << self
  end

  def possible_parents
    Category.where.not(id: descendants.map(&:id) << id)
  end

  def to_s
    name || super
  end

  sifter :full_text_search do |needle|
    pattern = "%#{needle}%"
    name.matches(pattern)
  end
end
