class AddReminderSentToActivity < ActiveRecord::Migration
  def self.up
    add_column :activities, :reminder_sent , :boolean, :default=> false
    Activity.reset_column_information
    Activity.update_all("reminder_sent = false")
  end

  def self.down
    remove_column :activities, :reminder_sent
  end
end
