class Question < ActiveRecord::Base

  validates :question, :presence=>true, :length=> {:maximum=>1000, :if => Proc.new{|q| !q.answer.blank? } }
  validates :answer, :presence=>true
  validates :position, :presence=>true, :numericality=>true
  belongs_to :activity_category
  
  default_scope order("position ASC")
  
  def move_to(position)
    initial = self.position
    if initial > position
      Question.update_all( "position = (position + 1)", :position => position..initial )
      self.update_attribute("position", position)
    elsif initial < position
      Question.update_all( "position = (position - 1)", :position => initial..position )
      self.update_attribute("position", position)
    end
  end
  
  def self.per_page
    100 
  end
  
  def after_destroy
    # update order
    Question.update_all( "position = (position - 1)", "position > #{self.position}" )
  end
  
  def after_create
    # set position to the maximum position + 1
    self.update_attribute( :position, (Question.maximum('position') || 0) + 1 )
  end
  
end
