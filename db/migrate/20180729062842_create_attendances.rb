class CreateAttendances < ActiveRecord::Migration[5.2]
  def change
    create_table :attendances do |t|
      t.datetime :clock_in_time
      t.datetime :clock_out_time
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
