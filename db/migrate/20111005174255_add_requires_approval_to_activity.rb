class AddRequiresApprovalToActivity < ActiveRecord::Migration
  def self.up
    add_column :activities, :requires_approval , :boolean, :default=> false
  end

  def self.down
    remove_column :activities, :requires_approval
  end
end
