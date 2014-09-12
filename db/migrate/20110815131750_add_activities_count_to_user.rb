class AddActivitiesCountToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :accepted_activities_requests_count , :integer, :default=>0

    User.reset_column_information
    User.all.each{|u| u.update_attribute(:accepted_activities_requests_count, 0)}
    ActivitiesRequest.all.each do |ar|
      if ar.status == ActivitiesAuthorityStatus.accepted
        ar.volunteer.increment!('accepted_activities_requests_count') if ar.volunteer
      end
    end
    
  end

  def self.down
    remove_column :users, :accepted_activities_requests_count
  end
end
