class AddKindToEvents < ActiveRecord::Migration
  def change
    add_column :events, :kind, :integer
  end
end
