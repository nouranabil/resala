class AddStatusAndRemovePublishedFromActivitiesTable < ActiveRecord::Migration
  def self.up
    remove_column :activities, :published
    add_column :activities, :status , :integer, :default=>1
    
  end

  def self.down
    remove_column :activities, :status
    add_column :activities, :published , :boolean, :default=>false
  end
end
