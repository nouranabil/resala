class AddDescToMediaTable < ActiveRecord::Migration
  def self.up
  	add_column :media, :desc , :string, :default => ''
  	
  	Media.update_all :desc=> ''
  end

  def self.down
	remove_column :media, :desc 
  end
end
