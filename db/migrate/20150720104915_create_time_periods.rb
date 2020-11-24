class CreateTimePeriods < ActiveRecord::Migration[4.2]
  def change
    create_table :time_periods do |t|
      t.timestamps null: false
      t.string :kind, index: true
      t.references :event, index: true
      t.datetime :min
      t.datetime :max
    end
  end
end
