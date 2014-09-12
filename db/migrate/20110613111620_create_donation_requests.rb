class CreateDonationRequests < ActiveRecord::Migration
  def self.up
    create_table :donation_requests do |t|
      t.string          :name
      t.string          :address
      t.string          :phone
      t.string          :email
      t.integer         :city_id
      t.timestamps
    end
  end

  def self.down
    drop_table :donation_requests
  end
end
