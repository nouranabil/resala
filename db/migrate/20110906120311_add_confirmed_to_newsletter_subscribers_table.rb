class AddConfirmedToNewsletterSubscribersTable < ActiveRecord::Migration
  def self.up
    add_column :newsletter_subscribers, :confirmed , :boolean, :default => false
    
    NewsletterSubscriber.update_all :confirmed=>false
  end
  
  def self.down
    remove_column :newsletter_subscribers, :confirmed
  end
end
