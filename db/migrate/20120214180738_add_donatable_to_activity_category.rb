class AddDonatableToActivityCategory < ActiveRecord::Migration
  def self.up
    add_column :activity_categories, :donatable, :boolean, :default => true
    ActivityCategory.update_all( :donatable => true)
  end

  def self.down
    remove_column :activity_categories, :donatable
  end
end
