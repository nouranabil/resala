class AddPaperclipAttributesToMediaTable < ActiveRecord::Migration
  def self.up
    add_column :media, :media_upload_type , :string, :default=>"Facebook"
    add_column :media, :status , :integer, :default=>Status.accepted
    add_column :media, :processed , :boolean, :default=>true
    
    # these fields are required to save the upload details  
    add_column :media, :media_file_name , :string
    add_column :media, :media_content_type , :string
    add_column :media, :media_file_size , :integer
    add_column :media, :media_updated_at , :datetime
    
    change_column :media, :fb_id, :string, :null=>true
    
    Media.update_all :media_upload_type => "Facebook", :status => Status.accepted, :processed => true
  end

  def self.down
    remove_column :media, :media_upload_type
    remove_column :media, :status
    remove_column :media, :processed
    remove_column :media, :media_file_name
    remove_column :media, :media_content_type
    remove_column :media, :media_file_size
    remove_column :media, :media_updated_at
    change_column :media, :fb_id, :string, :null=>false
  end
end
