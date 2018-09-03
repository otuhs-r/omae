class RemoveTimesFromUsers < ActiveRecord::Migration[5.2]
  def change
    remove_column :users, :work_start_time, :time
    remove_column :users, :work_end_time, :time
    remove_column :users, :rest_start_time, :time
    remove_column :users, :rest_end_time, :time
  end
end
