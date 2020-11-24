class AddGenderToItems < ActiveRecord::Migration[4.2]
  def change
    add_column :items, :gender, :integer
  end
end
