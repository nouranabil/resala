class AddSummaryToActivitiesTable < ActiveRecord::Migration
  def self.up
	add_column :activities, :summary , :text
  end

  def self.down
  	remove_column :activities, :summary
  end
end
