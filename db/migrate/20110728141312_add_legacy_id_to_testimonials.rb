class AddLegacyIdToTestimonials < ActiveRecord::Migration
  def self.up
    add_column :testimonials, :legacy_id, :integer
  end

  def self.down
    remove_column :testimonials, :legacy_id
  end
end
