class IncreaseDescriptionLengthForActivityCategoryAndTestimonial < ActiveRecord::Migration
  def self.up
    change_column(:activity_categories, :description, :text)
    change_column(:testimonials, :description, :text)
  end

  def self.down
    ActivityCategory.all.each do |ac| 
      ac.description = ac.description[0..254]
      ac.save 
    end
    testimonial.all.each do |t| 
      t.description = t.description[0..254]
      t.save 
    end
    change_column(:activity_categories, :description, :string , :limit=>255)
    change_column(:testimonials, :description, :string , :limit=>255)
  end
end
