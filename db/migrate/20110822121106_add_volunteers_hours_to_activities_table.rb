class AddVolunteersHoursToActivitiesTable < ActiveRecord::Migration
  def self.up
	  add_column :activities, :volunteers_hours , :integer
  end

  def self.down
	remove_column :activities, :volunteers_hours
  end
end
