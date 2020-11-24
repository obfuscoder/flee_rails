class AddKindToEvent < ActiveRecord::Migration[4.2]
  def change
    add_column :events, :kind, :integer
  end
end
