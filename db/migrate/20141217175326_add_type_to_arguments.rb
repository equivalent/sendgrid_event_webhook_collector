class AddTypeToArguments < ActiveRecord::Migration
  def change
    add_column :arguments, :type, :string
  end
end
