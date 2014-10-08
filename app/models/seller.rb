class Seller < ActiveRecord::Base
  has_many :item, dependent: :destroy
  has_many :reservation, dependent: :destroy

  validates_presence_of :first_name, :last_name, :street, :zip_code, :city, :phone, :email
  validates :email, uniqueness: true

  def to_s
    "#{first_name} #{last_name}"
  end
end
