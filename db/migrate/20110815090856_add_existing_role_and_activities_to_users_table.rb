class AddExistingRoleAndActivitiesToUsersTable < ActiveRecord::Migration
  def self.up
    add_column :users, :request_activities , :string
    add_column :users, :existing_role , :string
  end

  def self.down
    remove_column :users, :request_activities
    remove_column :users, :existing_role
  end
end
