class IncreaseActivityCategoryShortDescription < ActiveRecord::Migration
  def self.up
    change_column(:activity_categories, :short_description, :string , :limit=>600)
  end

  def self.down
    ActivityCategory.all.each do |ag| 
      ag.short_description = a.short_description[0..254]
      a.save 
    end
    change_column(:activity_categories, :short_description, :string , :limit=>255)
  end
end
