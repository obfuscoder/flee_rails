class AddMaxDonationsToCategories < ActiveRecord::Migration[7.0]
  def change
    add_column :categories, :max_donations, :integer
  end
end
