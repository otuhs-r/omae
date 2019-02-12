class AddIndexToUser < ActiveRecord::Migration[5.2]
  def change
    add_index :users, :user_name
  end
end
