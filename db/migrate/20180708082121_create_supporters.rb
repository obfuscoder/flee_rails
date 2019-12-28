class CreateSupporters < ActiveRecord::Migration
  def change
    create_table :supporters do |t|
      t.timestamps null: false

      t.references :support_type, index: true, foreign_key: true
      t.references :seller, index: true, foreign_key: true
    end

    add_index :supporters, %i[support_type_id seller_id], unique: true
  end
end
