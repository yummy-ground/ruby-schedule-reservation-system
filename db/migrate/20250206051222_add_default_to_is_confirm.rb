class AddDefaultToIsConfirm < ActiveRecord::Migration[8.0]
  def change
    change_column_default :schedules, :is_confirm, false
  end
end
