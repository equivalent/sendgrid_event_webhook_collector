class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.json :raw
    end
  end
end
