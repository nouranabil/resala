class Activity < ActiveRecord::Base
  belongs_to :user
  has_and_belongs_to_many :activity_categories
  has_and_belongs_to_many :branches
  has_many :activities_requests, :dependent=>:destroy
  has_many :volunteers, :through => :activities_requests
  has_many :accepted_volunteers, :through => :activities_requests,:conditions=>"activities_requests.status = #{Status.accepted}", :source => :volunteer
  has_many :achievements, :dependent=>:destroy
  has_many :achievements_types, :through => :achievements
  has_and_belongs_to_many :media, :class_name=> 'Media'
  belongs_to :front_photo, :class_name => "Media"
  
  scope :published, where(:status => ActivitiesStatus.accepted)
  scope :latest, order("created_at desc")
  scope :upcoming, where("NOT status IN (#{ActivitiesStatus.closed},#{ActivitiesStatus.request_close},#{ActivitiesStatus.request_cancel},#{ActivitiesStatus.cancelled})")
  scope :previous, where("status IN (#{ActivitiesStatus.closed},#{ActivitiesStatus.request_close},#{ActivitiesStatus.request_cancel})")
  scope :not_cancelled, where("status <> #{ActivitiesStatus.cancelled}")
  scope :not_by_user, lambda{|user_id|
    where("user_id <> #{user_id}")
  }
  
  validates :title, :presence=>true, :length=>{:maximum=>250}
  validates :facebook_post_message, :length=>{:maximum=>2000},:allow_blank => true
  validates :description, :presence=>true, :length=>{:maximum=>5000}
  validates :duration, :length=>{:maximum=>50}
  validates :required_volunteers_count, :numericality=>{:only_integer => true}
  validates :activity_categories, :presence=>true
  validates :location, :length=>{:maximum=>250}
  validates :volunteers_skills, :length=>{:maximum=>2000}
  validates :start_date, :presence=>true
  validates :branches, :presence=>true
  
  validate :activity_owner_must_be_authorized
  
  #validates :achievements, :presence=>true, :if=>Proc.new{|a| a.status == ActivitiesStatus.closed || a.status == ActivitiesStatus.request_close}
  
  accepts_nested_attributes_for :activity_categories, :reject_if => proc{|attrs| attrs.all? {|k, v| v.blank?}}
  accepts_nested_attributes_for :branches, :reject_if => proc{|attrs| attrs.all? {|k, v| v.blank?}}
  accepts_nested_attributes_for :achievements,:allow_destroy => true, :reject_if => proc{|attrs| attrs.all? {|k, v| v.blank?}}
  accepts_nested_attributes_for :media, :reject_if => proc{|attrs| attrs.all? {|k, v| v.blank?}}

  def self.per_page
    20
  end
  
  def activity_owner_must_be_authorized
    allowed_categories = (self.user.request_activities ||= "").split(",").collect(&:to_i)
    unless !(self.new_record?) || self.user.admin? || (self.user.activities_authority_status == ActivitiesAuthorityStatus.accepted && self.activity_categories.all?{|ac| allowed_categories.include?(ac.id)})
      errors.add(:activity_categories, I18n.t('activerecord.errors.messages.unauthorized_category'))
    end
  end
  
  def after_save
    if self.volunteers_hours_changed? && self.status == ActivitiesStatus.closed && !(self.accepted_volunteers.empty?)
      Volunteer.update_all("activities_hours = activities_hours + #{(self.volunteers_hours - self.volunteers_hours_was)||0}","id IN (#{self.accepted_volunteers.collect(&:id).join(",")})")
    end
  end
  
  def publish!(url,notification_url,branch_only = false)
  
    # update activity status
    self.status = ActivitiesStatus.accepted
    self.save!
    
    #Enqueue reminder
    Resque.enqueue_at(self.start_date - 25.hours, ActivityReminder, self.id)
    
    # email owner to notify him
    if self.user.email
      Mailer.activity_published(self.id,url).deliver unless self.user.admin?
    end
    
    # Announce by email and on facebook
    self.announce!(:facebook_announce=> self.facebook_announce, :email_notifications=> self.email_notifications, :branch_only=> branch_only)
    
    # move photos to facebook
    # Resque.enqueue(MoveToFacebook, "Activity", self.id) if self.front_photo && ! self.front_photo.processed 
    
    return true
  end
  
  def announce!(options={:facebook_announce=> true, :email_notifications=>true, :branch_only=> false})
    # post to facebook
    self.facebook_post_message = options[:facebook_post_message] if options[:facebook_post_message]
    ProvidersShare.new(nil, true, nil, self).activity_share if options[:facebook_announce]
    
    # email volunteers of the same branch/category
    if options[:email_notifications]
      recipients = self.activity_categories.inject([]){|list,ac| list + (ac.volunteers.emailable.select(:id).collect(&:id)) }
      if options[:branch_only]
        br_recipients = self.branches.inject([]){|list,branch| list + (branch.volunteers.emailable.select(:id).collect(&:id)) }
        recipients &= br_recipients 
      end
      recipients.uniq!
      recipients.delete(self.user_id)
      if !recipients.empty?
        Volunteer.update_all("has_pending_notifications = true","id IN (#{recipients.join(",")})")
        Volunteer.update_all("pending_notifications = (COALESCE(pending_notifications,'')||' #{self.id}')","id IN (#{recipients.join(",")})")
      end
    end
    return true
  end
  
  def email_counts(categories = true, branch_only=false)
    categories_list = categories ? self.activity_categories.select('id').collect(&:id) : []
    branches_list = branch_only ? self.branches.select('id').collect(&:id) : []
    Activity.email_counts(categories_list,branches_list)
  end
  
  def self.email_counts(categories = [], branches = [])
    recipients = []
    if !categories.blank?
      recipients = ActivityCategory.where(:id=>categories).inject([]){|list,ac| list + (ac.volunteers.emailable.select(:id).collect(&:id)) }
      recipients.uniq!
    end
    if !branches.blank?
      br_recipients = Branch.where(:id=>categories).inject([]){|list,branch| list + (branch.volunteers.emailable.select(:id).collect(&:id)) }
      recipients &= br_recipients 
    end
    recipients.uniq!
    return recipients.length
  end
  
  def remind_volunteers!
    self.accepted_volunteers.select('"users".id').each do |v|
      puts "reminding volunteer #{v.name} about activity #{self.id}"
      Mailer.activity_start_reminder(self.id, v.id).deliver
    end
    self.update_attribute(:reminder_sent, true)
  end
  
  def reject!(url)
    #update activity status
    self.status = ActivitiesStatus.rejected
    self.save!
    #email owner to notify him with reason and contact info
    if self.user.email
      Mailer.activity_rejected(self.id,url).deliver
    end 
  end
  
  def accept_close!(dashboard_url = nil, public_url = nil, post_to_facebook = false, message = "")
    begin
      ActiveRecord::Base.transaction do
        #update activity status
        if self.status == ActivitiesStatus.request_cancel
          self.status = ActivitiesStatus.cancelled
          self.save
          Mailer.activity_cancelled_notify_owner(self.id,dashboard_url).deliver
          #delete activity photos from server
          if self.media.files.not_processed.size > 0
            
          end
        elsif self.status == ActivitiesStatus.request_close
          self.status = ActivitiesStatus.closed
          self.save
          #add hours to participating users
          unless self.volunteers.empty?
            Volunteer.update_all("activities_hours = activities_hours + #{self.volunteers_hours || 0}","id IN (#{self.accepted_volunteers.collect(&:id).join(",")})")
          end
          #share on facebook
          ProvidersShare.new(nil, false, nil, self, message).close_activity_share if post_to_facebook
          #notify owner
          Mailer.activity_closed_notify_owner(self.id,dashboard_url).deliver
          #notify volunteers with the added hours
          unless self.volunteers.empty?
            Mailer.activity_closed_notify_volunteers(self.id,public_url).deliver
          end
        end
      end
      return true
    rescue
      return false
    end
  end
  
  def reject_close!(url,reason=nil)
    begin
      Activity.transaction do
        previous_status = self.status
        #update rejection reason
        self.rejection_reason = reason||""
        #update activity status
        self.status = ActivitiesStatus.accepted
        self.save!
        #notify owner
        Mailer.activity_closing_rejected_owner_notification(self.id,url,previous_status).deliver
      end
      return true
    rescue
      return false
    end
  end
  
  def image_url
    return self.front_photo.url if self.front_photo 
    return self.media.first.url if !self.media.empty?
    return "#{SITE_URL}/images/fb_logo.png"
  end
  
  def finished?
    self.status == ActivitiesStatus.closed || self.status == ActivitiesStatus.request_close || self.status == ActivitiesStatus.request_cancel || self.status == ActivitiesStatus.cancelled 
  end
  
  def confirmed_finished?
    self.status == ActivitiesStatus.closed || self.status == ActivitiesStatus.cancelled
  end
  
  def pending_finished?
    self.status == ActivitiesStatus.request_close || self.status == ActivitiesStatus.request_cancel
  end
  
  def cancelled?
    self.status == ActivitiesStatus.cancelled
  end
  
  index do
    title
    description
  end
  
end
