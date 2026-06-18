class AddFieldsToUsers < ActiveRecord::Migration[8.1]
  def change
    add_column :users, :name, :string, null: false, default: ""
    add_column :users, :role, :integer, null: false, default: 0
    add_column :users, :active, :boolean, null: false, default: true
    add_column :users, :session_timeout_minutes, :integer, null: false, default: 480

    add_index :users, :role
    add_index :users, :active
  end
end
