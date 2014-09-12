class ExtendActivityCategoryDescriptionLimit < ActiveRecord::Migration
  def self.up
    change_column(:activity_categories, :description, :string , :limit=>2000)
  end

  def self.down
    change_column(:activity_categories, :description, :string , :limit=>255)
  end
end
