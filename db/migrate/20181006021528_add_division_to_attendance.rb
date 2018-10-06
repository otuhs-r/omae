class AddDivisionToAttendance < ActiveRecord::Migration[5.2]
  def change
    add_column :attendances, :division, :integer, default: 0, null: false
  end
end
