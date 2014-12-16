class CreateArgumentsTable < ActiveRecord::Migration
  def change
    create_table :arguments do |t|
      t.integer :event_id
      t.string :name
      t.string :value
      t.datetime :created_at
      t.datetime :updated_at
    end
  end
end
