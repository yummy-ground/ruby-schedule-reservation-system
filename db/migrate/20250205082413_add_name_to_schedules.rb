class AddNameToSchedules < ActiveRecord::Migration[8.0]
  def change
    add_column :schedules, :name, :string
  end
end
