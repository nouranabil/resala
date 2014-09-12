class CreateBranchesMedia < ActiveRecord::Migration
  def self.up
    create_table :branches_media, :id=> false  do |t|
      t.integer :branch_id
      t.integer :media_id
    end
  end

  def self.down
    drop_table :branches_media
  end
end
