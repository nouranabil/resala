class BulkEmail
  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming

  attr_accessor :subject, :body, :recipients, :newsletter, :branches, :activity_categories, :media, :send_to_admins, :newsletter_version
  validates :subject, :presence=>true, :length=>{:maximum=>250}
  validates :body, :presence=>true, :length=>{:maximum=>5000}
  validates :recipients, :presence=>true
  
  def initialize(attributes = {})
    attributes.each do |name, value|
      send("#{name}=", value)
    end
    self.branches = [] if !self.branches
    self.activity_categories = [] if !self.activity_categories
    self.media = [] if !self.media
  end
  
  def persisted?
    false
  end

  def save
    if valid?
      while !(self.recipients.empty?)
        batch = self.recipients.slice!(0,100)
        Mailer.bulk_email(self.subject,self.body,self.media,batch,self.newsletter_version).deliver if batch.size > 0
      end
      return true
    else
      return false
    end
  end
end