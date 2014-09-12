class AddReviewedToDonationRequestsTable < ActiveRecord::Migration
  def self.up
    add_column :donation_requests, :reviewed, :boolean, :default=>false
    
  end

  def self.down
    remove_column :donation_requests, :reviewed
  end
end
