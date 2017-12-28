# frozen_string_literal: true

class Category < ActiveRecord::Base
  extend ActiveModel::Translation

  acts_as_paranoid

  belongs_to :client
  has_many :items
  has_many :children, class_name: Category, foreign_key: :parent_id, dependent: :restrict_with_error
  belongs_to :parent, class_name: Category

  validates_presence_of :client
  validates :name, presence: true, uniqueness: true
  validates :max_items_per_seller, numericality: { only_integer: true, allow_blank: true }

  scope :search, ->(needle) { needle.nil? ? all : where.has { sift :full_text_search, needle } }
  scope :selectable, -> { joining { children.outer }.where.has { children.id.eq nil } }

  def self.item_groups
    joining { items }.grouping { name }.selecting { [name, items.id.count.as('count')] }
                     .ordering { items.id.count.desc }
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

  def most_limited_category
    [self, parent.try(:most_limited_category)].compact.select(&:max_items_per_seller).min_by(&:max_items_per_seller)
  end

  def self_and_parents
    [self] + (parent ? parent.self_and_parents : [])
  end

  def to_s
    name || super
  end

  sifter :full_text_search do |needle|
    pattern = "%#{needle}%"
    name =~ pattern
  end
end
