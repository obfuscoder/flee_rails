class AddCountColumnToMessages < ActiveRecord::Migration[4.2]
  def change
    add_column :messages, :count, :integer
  end
end
