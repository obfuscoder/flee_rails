class AddCommentsToSupporter < ActiveRecord::Migration[4.2]
  def change
    add_column :supporters, :comments, :string
  end
end
