class AddTimesToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :work_start_time, :datetime
    add_column :users, :work_end_time, :datetime
    add_column :users, :rest_start_time, :datetime
    add_column :users, :rest_end_time, :datetime
  end
end
