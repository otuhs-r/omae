class AddIndexToAttendance < ActiveRecord::Migration[5.2]
  def change
    add_index :attendances, :date
  end
end
