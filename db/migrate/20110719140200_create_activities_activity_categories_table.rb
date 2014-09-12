class CreateActivitiesActivityCategoriesTable < ActiveRecord::Migration
  def self.up
    create_table :activities_activity_categories, :id => false  do |t|
      t.integer :activity_id
      t.integer :activity_category_id
    end
  end

  def self.down
    drop_table :activities_activity_categories
  end
end
