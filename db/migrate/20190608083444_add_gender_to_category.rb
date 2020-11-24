class AddGenderToCategory < ActiveRecord::Migration[4.2]
  def change
    add_column :categories, :gender, :boolean
  end
end
