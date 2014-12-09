class AddPublicUidToEvents < ActiveRecord::Migration
  def change
    add_column :events, :public_uid, :string
    add_index  :events, :public_uid
  end
end
