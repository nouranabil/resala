class AddReasonToActivitiesRequestsTable < ActiveRecord::Migration
  def self.up
	add_column :activities_requests, :reject_reason , :string
  end

  def self.down
	  remove_column :activities_requests, :reject_reason
  end
end
