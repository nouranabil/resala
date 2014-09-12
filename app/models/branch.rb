class Branch < ActiveRecord::Base
  before_destroy :before_destroy_method
  validates :name, :presence=>true, :uniqueness=>true, :length=>{:maximum=>250}
  validates :description,:length=>{:maximum=>2000}
  validates :city, :presence=>true
  validates :address, :presence=>true
  validates :email, :format=>{:with => /^[A-Za-z0-9._]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}$/ , :unless => Proc.new{|e| e.email.blank?} }
  validates :phones, :length=>{:maximum=>100, :minimum=>7, :allow_blank=>true}, :format=>{:with => /^[0-9\s\-]+$/ , :unless => Proc.new{|b| b.phones.blank?} }
  
  belongs_to :city
  has_and_belongs_to_many :activity_categories
  has_and_belongs_to_many :articles
  has_and_belongs_to_many :media, :class_name=> 'Media'
  has_and_belongs_to_many :activities
  has_many :volunteers
  
  accepts_nested_attributes_for :activity_categories, :reject_if => proc{|attrs| attrs.all? {|k, v| v.blank?}}
  
  scope :latest, order("created_at desc")
  
  attr_accessor :alternative_branch
  
  def self.branches_list
    Branch.order("city_id").collect{|b| ["#{b.city.name} - #{b.name}", b.id]}
  end
  
  def before_destroy_method
    # volunteers
    self.volunteers.update_all(:branch_id => self.alternative_branch.id )
    # activities
    self.activities.each{ |ac| 
      ac.branches << self.alternative_branch if !ac.branches.include? self.alternative_branch 
    }
    # related articles
    self.articles.each{|ar|
      ar.branches << self.alternative_branch if !ar.branches.include? self.alternative_branch
    }
  end
end
