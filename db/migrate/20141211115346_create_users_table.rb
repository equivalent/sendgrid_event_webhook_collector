class CreateUsersTable < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :public_uid
      t.string :name
      t.string :token
      t.string :application_name
      t.datetime :create_at
      t.datetime :updated_at
    end
  end
end
