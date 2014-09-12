class AddPendingNotificationsToVolunteer < ActiveRecord::Migration
  def self.up
    add_column :users, :pending_notifications, :string
    add_column :users, :has_pending_notifications, :boolean, :default=>false
  end

  def self.down
    remove_column :users, :pending_notifications
    remove_column :users, :has_pending_notifications
  end
end
