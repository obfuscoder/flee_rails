# frozen_string_literal: true

class User < ActiveRecord::Base
  authenticates_with_sorcery!

  attr_accessor :old_password
  attr_accessor :password_confirmation

  belongs_to :client

  validates :email, uniqueness: { scope: :client_id }
  validates :password, confirmation: { on: :update }
  validates :client, presence: true
  validates :old_password, :password, :password_confirmation, presence: { on: :update }
  validate :old_password_correct, on: :update
  validate :password_differs_from_old_password, on: :update
  validate :password_strength, on: :update

  private

  def old_password_correct
    # We cannot use valid_password?(old_password) as the salt and encrypted_password has been changed already.
    # So we have to fetch the user from the database again and then use valid_password? on that instance.
    errors.add(:old_password, :incorrect) unless User.find(id).valid_password?(old_password)
  end

  def password_differs_from_old_password
    errors.add(:password, :no_change) if password == old_password
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
