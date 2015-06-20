class Category < ActiveRecord::Base
  extend ActiveModel::Translation

  has_many :items, dependent: :destroy

  validates :name, presence: true, uniqueness: true

  def to_s
    name || super
  end
end
