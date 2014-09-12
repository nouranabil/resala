class UpdateActivitiesBranchesTable < ActiveRecord::Migration
  def self.up
    remove_column :activities_branches, :activity_category_id
    add_column :activities_branches, :activity_id , :integer
  end

  def self.down
    remove_column :activities_branches, :activity_id
    add_column :activities_branches, :activity_category_id, :integer
  end
end
