class AddActivityCategoryToDonation < ActiveRecord::Migration
  def self.up
    add_column :donations, :activity_category_id, :integer
  end

  def self.down
    remove_column :donations, :activity_category_id
  end
end
