class AddPhoneEmailToDonationTable < ActiveRecord::Migration
  def self.up
	add_column :donations, :phone , :string
	add_column :donations, :email , :string
  end

  def self.down
	  remove_column :donations, :phone
	  remove_column :donations, :email
  end
end
