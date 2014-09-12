class AddNameToNewsletterSubscribersTable < ActiveRecord::Migration
  def self.up
    add_column :newsletter_subscribers, :name, :string
  end

  def self.down
    remove_column :newsletter_subscribers, :name
  end
end