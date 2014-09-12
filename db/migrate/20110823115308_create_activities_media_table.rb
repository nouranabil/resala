class CreateActivitiesMediaTable < ActiveRecord::Migration
  def self.up
    create_table :activities_media, :id=> false  do |t|
      t.integer :activity_id
      t.integer :media_id
    end
  end

  def self.down
    drop_table :activities_media
  end
end
