class CreateEmails < ActiveRecord::Migration[4.2]
  def change
    create_table :emails do |t|
      t.timestamps null: false

      t.references :seller, index: true, foreign_key: true
      t.string :to
      t.string :subject
      t.text :body
      t.boolean :sent
    end
  end
end
