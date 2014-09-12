class CreateBranches < ActiveRecord::Migration
  def self.up
    create_table :branches do |t|
      t.string  :name, :null=>false
      t.string  :description
      t.string  :address
      t.string  :phones
      t.integer :city_id
      t.float   :longitude
      t.float   :latitude
      t.timestamps
    end
  end

  def self.down
    drop_table :branches
  end
end
