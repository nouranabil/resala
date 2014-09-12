class AddFrontPhotoIdToActivity < ActiveRecord::Migration
  def self.up
    add_column :activities, :front_photo_id , :integer
  end

  def self.down
    remove_column :activities, :front_photo_id
  end
end
