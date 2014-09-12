class CreateActivityCategoriesVolunteersTable < ActiveRecord::Migration
  def self.up
    create_table :activity_categories_volunteers, :id => false  do |t|
      t.integer :volunteer_id
      t.integer :activity_category_id
    end
  end

  def self.down
    drop_table :activity_categories_volunteers
  end
end
