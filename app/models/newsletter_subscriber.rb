class NewsletterSubscriber < ActiveRecord::Base
  validates :name, :presence=>true, :length=>{:maximum=>250}
  validates :email, :presence=>true, :format=>{:with => /^[A-Za-z0-9._-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}$/ , :unless => Proc.new{|e| e.email.blank?}, :message => I18n.t("messages.incorrect_email")}
  validates_uniqueness_of :email, :message => I18n.t("messages.email_exists")
  
  scope :confirmed, where(:confirmed => true)
  scope :unconfirmed, where(:confirmed => false)
  
  def self.per_page
    20
  end
end
