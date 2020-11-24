class CreateReviews < ActiveRecord::Migration[4.2]
  def change
    create_table :reviews do |t|
      t.timestamps null: false

      t.references :event, index: true
      t.references :seller, index: true
    end
  end
end
