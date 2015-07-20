class CreateTimePeriods < ActiveRecord::Migration
  def change
    create_table :time_periods do |t|
      t.timestamps null: false
      t.string :type, index: true
      t.references :event, index: true
      t.datetime :from
      t.datetime :to
    end
  end
end
