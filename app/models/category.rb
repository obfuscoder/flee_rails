# frozen_string_literal: true

class Category < ApplicationRecord
  extend ActiveModel::Translation

  acts_as_paranoid

  # !! we must not specify dependent option as it would delete reservations/supports associations on soft delete
  # we should move away from 'paranoid' to 'paper_trail' or 'discard' to fix this
  belongs_to :client
  has_many :items
  has_many :sizes
  has_many :children, class_name: 'Category', foreign_key: :parent_id, inverse_of: :parent
  belongs_to :parent, class_name: 'Category', inverse_of: :children

  # in rails 5 there is _prefix to get rid of the 'size_'
  enum size_option: %i[size_optional size_required size_fixed size_disabled]

  validates :client, presence: true
  validates :name, presence: true, uniqueness: { scope: :client_id }
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
    client.categories.where.not(id: descendants.map(&:id) << id)
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
