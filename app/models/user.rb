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

  def self.find_by_credentials(credentials)
    relation = nil

    sorcery_config.username_attribute_names.each do |attribute|
      if sorcery_config.downcase_username_before_authenticating
        condition = arel_table[attribute].lower.eq(arel_table.lower(credentials[0]))
      else
        condition = arel_table[attribute].eq(credentials[0])
      end

      relation = if relation.nil?
                   condition
                 else
                   relation.or(condition)
                 end
    end

    current_client.users.where(relation).first
  end

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
