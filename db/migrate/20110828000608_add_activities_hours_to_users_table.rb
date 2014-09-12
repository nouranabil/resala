class AddActivitiesHoursToUsersTable < ActiveRecord::Migration
  def self.up
    add_column :users, :activities_hours , :integer, :default => 0
    
    User.update_all :activities_hours => 0
  end

  def self.down
    remove_column :users, :activities_hours
  end
end