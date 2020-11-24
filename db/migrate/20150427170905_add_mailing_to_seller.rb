class AddMailingToSeller < ActiveRecord::Migration[4.2]
  def change
    add_column :sellers, :mailing, :boolean
  end
end
