class IncreaseDescriptionLengthForTestimonialUrl < ActiveRecord::Migration
  def self.up
    change_column(:testimonials, :url, :string , :limit=>2000)
  end

  def self.down
    Testimonial.all.each do |t| 
      t.url = t.url[0..254]
      t.save
    end
    change_column(:testimonials, :url, :string , :limit=>255)
  end
end
