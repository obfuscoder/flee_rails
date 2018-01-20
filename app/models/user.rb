# frozen_string_literal: true

class User < ActiveRecord::Base
  authenticates_with_sorcery!

  attr_accessor :old_password
  attr_accessor :password_confirmation

  belongs_to :client

  validates :email, uniqueness: true
  validates_confirmation_of :password, on: :update
  validates_presence_of :client
  validates_presence_of :old_password, :password, :password_confirmation, on: :update
  validate :old_password_correct, on: :update
  validate :password_differs_from_old_password, on: :update
  validate :password_strength, on: :update

  private

  def old_password_correct
    errors.add(:old_password, :incorrect) if User.authenticate(email, old_password).nil?
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
