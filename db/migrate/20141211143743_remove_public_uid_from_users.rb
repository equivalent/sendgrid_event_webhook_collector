class RemovePublicUidFromUsers < ActiveRecord::Migration
  def up
    remove_column :users, :public_uid
  end

  def down
    add_column :users, :public_uid, :string
  end
end
