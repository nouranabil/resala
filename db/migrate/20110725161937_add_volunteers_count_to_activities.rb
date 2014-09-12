class AddVolunteersCountToActivities < ActiveRecord::Migration
  def self.up
    add_column :activities, :volunteers_count, :integer, :default => 0  
    
    Activity.reset_column_information  
    Activity.all.each do |a|  
      a.update_attribute :volunteers_count, a.activities_requests.accepted.length  
    end  
  end

  def self.down
    remove_column :activities, :volunteers_count
  end
end
