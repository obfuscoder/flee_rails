# frozen_string_literal: true

class ChangePrecisionOfSellerFeeInEvents < ActiveRecord::Migration
  def up
    change_column :events, :seller_fee, :decimal, precision: 4, scale: 2
  end
end
