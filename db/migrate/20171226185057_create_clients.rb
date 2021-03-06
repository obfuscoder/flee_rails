class CreateClients < ActiveRecord::Migration[4.2]
  def change
    create_table :clients do |t|
      t.timestamps null: false

      t.string :key
      t.string :prefix
      t.string :domain
      t.string :name
      t.string :short_name
      t.string :logo
      t.string :address
      t.string :invoice_address
      t.text   :intro
      t.text   :outro
      t.string :mail_address
      t.text   :terms
      t.decimal :reservation_fee, precision: 4, scale: 2
      t.decimal :commission_rate, precision: 3, scale: 2
      t.decimal :price_precision, precision: 3, scale: 2
      t.boolean :donation_of_unsold_items
      t.boolean :donation_of_unsold_items_default
    end
  end
end
