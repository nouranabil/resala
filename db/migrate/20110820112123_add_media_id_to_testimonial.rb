class AddMediaIdToTestimonial < ActiveRecord::Migration
  def self.up
    add_column :testimonials, :photo_id , :integer
  end

  def self.down
    remove_column :testimonials, :photo_id
  end
end
