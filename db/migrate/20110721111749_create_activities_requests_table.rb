class CreateActivitiesRequestsTable < ActiveRecord::Migration
  def self.up
    create_table :activities_requests  do |t|
      t.integer   :activity_id
      t.integer   :volunteer_id
      t.integer   :status, :default=>1
    end
  end

  def self.down
    drop_table :activities_requests
  end
end
