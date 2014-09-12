class AddFacebookPostMessageToActivity < ActiveRecord::Migration
  def self.up
    add_column :activities, :facebook_post_message , :string, :limit=>2000
  end

  def self.down
    remove_column :activities, :facebook_post_message
  end
end
