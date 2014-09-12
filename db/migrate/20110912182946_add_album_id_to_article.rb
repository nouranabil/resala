class AddAlbumIdToArticle < ActiveRecord::Migration
  def self.up
    add_column :articles, :album_id , :string
  end
  
  def self.down
    remove_column :articles , :album_id
  end
end
