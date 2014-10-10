class Category < ActiveRecord::Base
  has_many :item, dependent: :destroy

  validates :name, presence: true, uniqueness: true

  def to_s
    name || super
  end
end
