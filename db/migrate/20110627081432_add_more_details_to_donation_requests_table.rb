class AddMoreDetailsToDonationRequestsTable < ActiveRecord::Migration
  def self.up
    add_column :donation_requests, :mobile, :string
    add_column :donation_requests, :amount, :string
    add_column :donation_requests, :amount_period, :string
    add_column :donation_requests, :notes, :string
  end

  def self.down
    remove_column :donation_requests, :mobile
    remove_column :donation_requests, :amount
    remove_column :donation_requests, :amount_period
    remove_column :donation_requests, :notes
  end
end
