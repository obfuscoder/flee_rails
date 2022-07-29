class User < ApplicationRecord
  authenticates_with_sorcery!

  attr_accessor :old_password, :password_confirmation

  belongs_to :client

  validates :email, uniqueness: { scope: :client_id }
  validates :client, presence: true

  with_options on: :change_password do
    validates :password, confirmation: true
    validates :old_password, :password, :password_confirmation, presence: true
    validate :password_change
  end

  with_options on: :reset_password do
    validates :password, confirmation: true
    validates :password, :password_confirmation, presence: true
    validate :password_reset
  end

  private

  def old_password_correct
    # We cannot use valid_password?(old_password) as the salt and encrypted_password has been changed already.
    # So we have to fetch the user from the database again and then use valid_password? on that instance.
    errors.add(:old_password, :incorrect) unless User.find(id).valid_password?(old_password)
  end

  def password_differs_from_old_password
    errors.add(:password, :no_change) if password == old_password
  end

  # having multiple custom validator methods in the with_options blocks caused one validator not to be called.
  # no ideaa why. using a custom validator method for each with_options block/context solved the problem.
  def password_change
    old_password_correct
    password_differs_from_old_password
    password_strength
  end

  def password_reset
    password_strength
  end

  def password_strength
    errors.add(:password, :weak) unless password_strong?(password)
  end

  def password_strong?(password)
    password.size >= 5 &&
      password.match(/[[:digit:]]/) &&
      password.match(/[[:lower:]]/) &&
      password.match(/[[:upper:]]/)
  end
end
