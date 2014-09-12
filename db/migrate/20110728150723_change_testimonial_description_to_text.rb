class ChangeTestimonialDescriptionToText < ActiveRecord::Migration
  def self.up
    change_column(:testimonials, :description, :text)
  end

  def self.down
    change_column(:testimonials, :description, :string)
  end
end
