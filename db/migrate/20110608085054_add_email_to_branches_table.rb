class AddEmailToBranchesTable < ActiveRecord::Migration
  def self.up
    add_column :branches, :email, :string
  end

  def self.down
    remove_column :branches, :email
  end
end
