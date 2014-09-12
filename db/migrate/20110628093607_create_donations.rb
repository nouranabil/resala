class CreateDonations < ActiveRecord::Migration
  def self.up
    create_table :donations do |t|
      t.string :donator_name
      t.integer :amount, :null=> false
      t.integer :status, :default=> 0
      t.timestamps
    end
  end

  def self.down
    drop_table :donations
  end
end
