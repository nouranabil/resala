class ActivitiesRequest < ActiveRecord::Base
  belongs_to :volunteer
  belongs_to :activity 
  
  validates :volunteer, :presence=>true
  validates :activity, :presence=>true
  validates :reject_reason, :presence=>true, :if=>Proc.new{|ar| ar.status == ActivitiesStatus.rejected}
  validates :reject_reason, :length=>{:maximum=>250}
  
  scope :accepted, where(:status => ActivitiesStatus.accepted)
  scope :activities, lambda{|volunteer_id|
    select(:activity_id).where(:volunteer_id => volunteer_id)
  }
  
  def after_save
    self.update_counter_cache
    self.update_volunteers_activities_count
  end
  
  def after_create
    if !self.activity.requires_approval
      self.status = Status.accepted
      self.save!
      Mailer.volunteer_joined_notification(self.volunteer.id,self.activity.id).deliver
    end
  end
  
  def after_destroy
    self.update_counter_cache
  end
  
  def update_counter_cache
    self.activity.volunteers_count = self.activity.activities_requests.accepted.count
    self.activity.total_volunteers_count = self.activity.activities_requests.count
    self.activity.save
  end
  
  def update_volunteers_activities_count
    if self.status_changed?
      count = ActivitiesRequest.where(:volunteer_id=>self.volunteer_id,:status=>ActivitiesAuthorityStatus.accepted).count
      self.volunteer.update_attribute('accepted_activities_requests_count',count)
    end
  end
  
end
