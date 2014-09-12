class Achievement < ActiveRecord::Base
  validates :activity, :presence=>true
  validates :achievements_type, :presence=>true
  validates :amount, :presence=>true
  validates :amount, :numericality=>{:only_integer => true, :unless=>Proc.new{|a| a.amount.blank?} }
  validates :achievements_type_id, :uniqueness=>{:scope => [:activity_id]}
  
  belongs_to :activity
  belongs_to :achievements_type
end
