# frozen_string_literal: true

class Supporter < ActiveRecord::Base
  belongs_to :support_type
  belongs_to :seller
  validates :seller, uniqueness: { scope: :support_type_id }
end
