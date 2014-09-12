class AddShortDescriptionToActivityCategory < ActiveRecord::Migration
  def self.up
    add_column :activity_categories, :short_description , :string
  end

  def self.down
    remove_column :activity_categories, :short_description
  end
end
