class AddTotalVolunteersCountToActivity < ActiveRecord::Migration
  def self.up
    add_column :activities, :total_volunteers_count, :integer, :default => 0  
    Activity.reset_column_information
    Activity.all.each do |a|  
      a.update_attribute :total_volunteers_count, a.activities_requests.length  
    end
  end

  def self.down
    remove_column :activities, :total_volunteers_count
  end
end
