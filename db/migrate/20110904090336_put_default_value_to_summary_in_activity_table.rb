class PutDefaultValueToSummaryInActivityTable < ActiveRecord::Migration
  def self.up
	  change_column :activities, :summary , :text, :default => ''
	  Activity.update_all :summary => ''
  end

  def self.down
	  remove_column :activities, :summary
  end
end
