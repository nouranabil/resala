class Volunteer < User
  validates :gender, :presence=>true, :length=>{:maximum=>1}, :inclusion=>{:in=>["M", "F"], :if => Proc.new{|v| !v.gender.blank? && v.gender.length == 1}}
  validates :date_of_birth, :presence=>true
  
  validates :branch, :presence=>true
  # validates :activity_categories, :presence=>true
  
  validates :profession, :length=>{:maximum=>75}
  validates :profession, :presence=>true, :if=>Proc.new{|v| v.graduated == true}
  validates :company, :length=>{:maximum=>50}
  validates :university, :length=>{:maximum=>50}
  validates :university, :presence=>true, :if=>Proc.new{|v| v.graduated != true}
  validates :school_year, :length=>{:maximum=>25}
  validates :blood_type, :length=>{:maximum=>5}
  validates :blood_type, :presence=>true, :if=>Proc.new{|v| v.blood_donation == true}
  validates :available_days, :presence=>true
  
  has_and_belongs_to_many :activity_categories
  belongs_to :branch
  has_many :activities_requests, :dependent => :destroy
  
  
  compact_flags :available_days  => Day.all
  accepts_nested_attributes_for :activity_categories, :reject_if => proc{|attrs| attrs.all? {|k, v| v.blank?}}
  attr_accessor :city_id
  
  scope :with_pending_notifications, where(:has_pending_notifications => true)
  scope :for_activity_category, lambda{|activity_category_id|
    where("id in (#{ActivityCategoriesVolunteer.volunteers(activity_category_id).collect{|acv| acv.volunteer_id}.push(0).join(',')})")
  }
  
  index do
    name
  end
  
  def validate
    self.errors.add_to_base(I18n.t("messages.activities_not_valid")) if self.activity_categories.size == 0
  end
  
  def self.initialize_volunteer_with_omniauth(auth)
    return Volunteer.find_or_initialize_by_provider_and_uid(auth["provider"], auth["uid"], 
                      User.basic_attrs(auth).merge({:email=>auth["user_info"]["email"], :set_gender=>auth["extra"]["user_hash"]["gender"]}))
  end
  
  def city
    city_id.blank? ? nil : City.find(city_id)
  end
  
  def city_id
    @city_id || (self.branch.city_id if self.branch)
  end
  
  def available_days_names
    days_names = []
    Day.days.each do |day_en, day_ar|
      days_names << day_ar if self.send(day_en)
    end
    days_names.join(', ')
  end
  
  def stringify(attr)
    send(attr) ? I18n.t("messages.y") : I18n.t("messages.n")
  end
  
end
