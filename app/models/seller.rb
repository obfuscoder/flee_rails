class Seller < ActiveRecord::Base
  attr_accessor :accept_terms

  has_many :item, dependent: :destroy
  has_many :reservation, dependent: :destroy

  validates_presence_of :first_name, :last_name, :street, :zip_code, :city, :phone, :email

  validates_acceptance_of :accept_terms, on: :create
  validates :email, uniqueness: true

  def to_s
    "#{first_name} #{last_name}"
  end
end
