class AddFrontPhotoIdToArticle < ActiveRecord::Migration
  def self.up
    add_column :articles, :front_photo_id , :integer
  end

  def self.down
    remove_column :articles, :front_photo_id
  end
end
