class CreateReviews < ActiveRecord::Migration
  def change
    create_table :reviews do |t|
      t.references :event, index: true
      t.references :seller, index: true

      t.timestamps
    end
  end
end
