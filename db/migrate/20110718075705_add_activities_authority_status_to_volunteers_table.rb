class AddActivitiesAuthorityStatusToVolunteersTable < ActiveRecord::Migration
  def self.up
    add_column :users, :activities_authority_status, :integer
  end

  def self.down
    remove_column :users, :activities_authority_status
  end
end
