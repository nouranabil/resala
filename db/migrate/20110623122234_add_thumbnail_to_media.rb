class AddThumbnailToMedia < ActiveRecord::Migration
  def self.up
    add_column :media, :thumbnail, :string
  end

  def self.down
    remove_column :media, :thumbnail
  end
end
