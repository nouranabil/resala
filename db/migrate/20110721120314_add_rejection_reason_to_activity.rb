class AddRejectionReasonToActivity < ActiveRecord::Migration
  def self.up
    add_column :activities, :rejection_reason , :string, :limit=>500
  end

  def self.down
    remove_column :activities, :rejection_reason
  end
end
