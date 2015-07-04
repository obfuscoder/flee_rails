class AddMailingToSeller < ActiveRecord::Migration
  def change
    add_column :sellers, :mailing, :boolean
  end
end
