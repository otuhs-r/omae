class AddComplexIndexToAttendance < ActiveRecord::Migration[5.2]
  def change
    add_index :attendances, %i[user_id date]
  end
end
