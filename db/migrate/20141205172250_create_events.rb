class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.json :raw
      t.datetime :created_at
      t.datetime :updated_at
    end
  end
end
