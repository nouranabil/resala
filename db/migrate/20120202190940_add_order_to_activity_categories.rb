class AddOrderToActivityCategories < ActiveRecord::Migration
  def self.up
    add_column :activity_categories, :position , :integer, :default=> 1
    ActivityCategory.all.each_with_index{|ac,index| ac.update_attribute( "position" , index+1 ) }
  end

  def self.down
    remove_column :activity_categories, :position
  end
end
