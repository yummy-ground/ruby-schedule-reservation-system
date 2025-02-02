class CreateSchedules < ActiveRecord::Migration[8.0]
  def change
    create_table :schedules do |t|
      t.references :user, null: false, foreign_key: true
      t.integer :personnel, null: false
      t.datetime :start_datetime, null: false
      t.datetime :end_datetime, null: false
      t.boolean :is_confirm, null: false, default: true

      t.timestamps
    end
  end
end
