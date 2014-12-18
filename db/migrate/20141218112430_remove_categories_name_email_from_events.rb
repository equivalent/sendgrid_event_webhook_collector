class RemoveCategoriesNameEmailFromEvents < ActiveRecord::Migration
  def up
    remove_column :events, :name
    remove_column :events, :email
    remove_column :events, :categories
  end

  def down
    add_column :events, :categories, :text, default: [], array: true
    add_column :events, :email, :string
    add_column :events, :name, :string
  end
end
