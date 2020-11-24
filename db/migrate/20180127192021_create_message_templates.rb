class CreateMessageTemplates < ActiveRecord::Migration[4.2]
  def change
    create_table :message_templates do |t|
      t.timestamps null: false
      t.string :category
      t.string :subject
      t.text :body
    end
    add_reference :message_templates, :client, index: true, foreign_key: true
    add_index :message_templates, %i[category client_id], unique: true
  end
end
