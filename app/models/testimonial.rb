class Testimonial < ActiveRecord::Base
  validates :title, :presence=>true
  validates :source, :presence=>true
  validates :url, :length=>{:maximum=>2000}  ,:format=>{:with => /^((http|https):\/\/)?[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z0-9]{1,5}(([0-9]{1,5})?\/.*)?$/ix , :unless => Proc.new{|t| t.url.blank?} }
  validates :disclosure_date, :presence=>true
  belongs_to :photo, :class_name => "Media"
  
  scope :latest, order("created_at desc")
  
  def self.per_page
    20
  end
end
