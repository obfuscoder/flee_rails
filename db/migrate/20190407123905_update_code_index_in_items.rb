class UpdateCodeIndexInItems < ActiveRecord::Migration
  def change
    remove_index :items, :code
    add_index :items, %i[reservation_id code], unique: true
  end
end
