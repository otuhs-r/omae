class AddClumnToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :work_start_time, :time
    add_column :users, :work_end_time, :time
    add_column :users, :rest_start_time, :time
    add_column :users, :rest_end_time, :time
    add_column :users, :user_name, :string
  end
end
