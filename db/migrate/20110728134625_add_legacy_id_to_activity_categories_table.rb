class AddLegacyIdToActivityCategoriesTable < ActiveRecord::Migration
  def self.up
    add_column :activity_categories, :legacy_id, :integer
  end

  def self.down
    remove_column :activity_categories, :legacy_id
  end
end