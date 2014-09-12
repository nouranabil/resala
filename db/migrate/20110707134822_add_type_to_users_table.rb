class AddTypeToUsersTable < ActiveRecord::Migration
  def self.up
    add_column :users, :type, :string
    remove_column :users, :admin
  end

  def self.down
    remove_column :users, :type
    add_column :users, :admin, :boolean, :default => false
  end
end
