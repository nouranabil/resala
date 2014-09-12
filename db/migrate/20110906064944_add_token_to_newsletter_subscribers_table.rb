class AddTokenToNewsletterSubscribersTable < ActiveRecord::Migration
  def self.up
    add_column :newsletter_subscribers, :token , :string
  end

  def self.down
    add_column :newsletter_subscribers, :token
  end
end
