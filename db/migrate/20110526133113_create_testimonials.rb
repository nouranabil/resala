class CreateTestimonials < ActiveRecord::Migration
  def self.up
    create_table :testimonials do |t|
      t.string :title
      t.string :description
      t.string :source
      t.string :url
      t.date :disclosure_date

      t.timestamps
    end
  end

  def self.down
    drop_table :admin_testimonials
  end
end
