class AddCategorizationToEvents < ActiveRecord::Migration
  def change
    add_column :events, :categories, :text, default: [], array: true
    add_column :events, :email, :string
    add_column :events, :name, :string
    add_column :events, :occurred_at, :datetime
    add_column :events, :processed_at, :datetime
  end
end
