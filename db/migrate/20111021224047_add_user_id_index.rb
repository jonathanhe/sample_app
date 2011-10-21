class AddUserIdIndex < ActiveRecord::Migration
  def up
    add_index :microposts, :user_id
  end

  def down
    remove_index :microposts, :user_id
  end
end
