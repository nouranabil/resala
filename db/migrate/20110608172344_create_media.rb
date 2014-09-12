class CreateMedia < ActiveRecord::Migration
  def self.up
    create_table :media do |t|
      t.string    :fb_id, :null=>false
      t.string    :media_type, :null=>false
      t.timestamps
    end
  end

  def self.down
    drop_table :media
  end
end
