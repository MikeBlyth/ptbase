class DropAdminUser < ActiveRecord::Migration
  def up
    drop_table :admin_users
  end
end
