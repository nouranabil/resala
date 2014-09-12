class AddDurationTypeToActivitiesTable < ActiveRecord::Migration
  def self.up
    add_column :activities, :duration_type , :string
  end

  def self.down
    remove_column :activities, :duration_type
  end
end
