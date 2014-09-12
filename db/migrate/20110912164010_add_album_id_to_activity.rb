class AddAlbumIdToActivity < ActiveRecord::Migration
  def self.up
    add_column :activities, :album_id , :string
  end
  
  def self.down
    remove_column :activities , :album_id
  end
end
