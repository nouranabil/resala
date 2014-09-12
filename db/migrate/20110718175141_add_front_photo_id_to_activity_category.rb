class AddFrontPhotoIdToActivityCategory < ActiveRecord::Migration
  def self.up
    add_column :activity_categories, :front_photo_id , :integer
  end

  def self.down
    remove_column :activity_categories, :front_photo_id
  end
end
