class AddFacebookPostIdToArticlesTable < ActiveRecord::Migration
  def self.up
    add_column :articles, :facebook_post_id, :string
  end

  def self.down
    remove_column :articles, :facebook_post_id
  end
end
