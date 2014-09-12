class AchievementsType < ActiveRecord::Base
  validates :name, :presence=>true, :length =>{:maximum=>250}, :uniqueness => true
  has_many :achievements, :dependent=>:destroy
  has_many :activities, :through => :achievements
end