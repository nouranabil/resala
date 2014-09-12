class City < ActiveRecord::Base
  validates :name, :presence=>true, :uniqueness=>true
  
  has_many :branches
  has_many :donation_requests
  
  default_scope order("name")
end
