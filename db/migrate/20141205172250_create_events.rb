class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.json :raw
      t.datetime :create_at
      t.datetime :updated_at
    end
  end
end
