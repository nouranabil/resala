class CreateActivityCategoriesDonationRequestsTable < ActiveRecord::Migration
  def self.up
    create_table :activity_categories_donation_requests, :id=> false  do |t|
      t.integer :activity_category_id
      t.integer :donation_request_id
    end
  end

  def self.down
    drop_table :activity_categories_donation_requests
  end
end
