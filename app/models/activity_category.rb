class ActivityCategory < ActiveRecord::Base
  validates :name, :presence=>true, :uniqueness=>true, :length=>{:maximum=>250}
  acts_as_list
  validates :front_photo_id, :presence=>true
  validates :short_description,:presence=>true, :length=>{:maximum=>600}
  has_and_belongs_to_many :branches
  has_and_belongs_to_many :articles
  has_and_belongs_to_many :volunteers
  has_and_belongs_to_many :media, :class_name=> 'Media'
  has_and_belongs_to_many :activities
  has_and_belongs_to_many :donation_requests
  has_many :donations
  has_many :questions
  belongs_to :front_photo, :class_name => "Media"
  scope :latest, order("position ASC")
  scope :donatable, where(:donatable => true)
  default_scope order("position ASC")
  
  def front_photo_fb_id
    (photo = self.front_photo) ? photo.fb_id : nil
  end
  
  def front_photo_fb_id= fb_id
    self.front_photo = Media.find_by_fb_id fb_id
  end
end