class CreateStockMessageTemplates < ActiveRecord::Migration
  def change
    create_table :stock_message_templates do |t|
      t.string :category
      t.string :subject
      t.text :body

      t.timestamps null: false
    end
    add_index :stock_message_templates, :category, unique: true
  end
end
