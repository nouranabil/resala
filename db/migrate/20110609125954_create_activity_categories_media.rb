class CreateActivityCategoriesMedia < ActiveRecord::Migration
  def self.up
    create_table :activity_categories_media, :id=> false  do |t|
      t.integer :activity_category_id
      t.integer :media_id
    end
  end

  def self.down
    drop_table :activity_categories_media
  end
end
