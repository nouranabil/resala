class ChangeConfirmedDaysToBooleanInUsersTableToRepresentLimitedDaysOrNot < ActiveRecord::Migration
  def self.up
    remove_column :users, :days_to_confirm
    add_column :users, :limited_days , :boolean, :default => false
  end

  def self.down
    remove_column :users, :limited_days
  end
end
