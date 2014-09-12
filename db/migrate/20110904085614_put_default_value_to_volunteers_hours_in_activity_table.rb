class PutDefaultValueToVolunteersHoursInActivityTable < ActiveRecord::Migration
  def self.up
	  change_column :activities, :volunteers_hours , :integer, :default => 0
	  Activity.update_all :volunteers_hours => 0
  end

  def self.down
	  remove_column :activities, :volunteers_hours
  end
end
