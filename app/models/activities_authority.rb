class ActivitiesAuthority
  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming

  attr_accessor :existing_role, :request_activities, :volunteer
  validates :request_activities, :presence=>true
  validates :volunteer, :presence=>true
  validates :existing_role, :length=>{:maximum=>250}
  
  def initialize(attributes = {})
    attributes.each do |name, value|
      send("#{name}=", value)
    end
  end
  
  def persisted?
    false
  end

  def save
    if valid?
      self.volunteer.update_attributes(:activities_authority_status=>ActivitiesAuthorityStatus.requested, 
                                       :request_activities=>self.request_activities.join(','),
                                       :existing_role=>self.existing_role)
      Mailer.activity_authority_request_admins_notification(self.volunteer.id).deliver
      return true
    else
      return false
    end
  end
end