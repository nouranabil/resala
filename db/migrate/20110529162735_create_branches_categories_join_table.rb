class CreateBranchesCategoriesJoinTable < ActiveRecord::Migration
  def self.up
    create_table :activity_categories_branches, :id => false  do |t|
      t.integer :branch_id
      t.integer :activity_category_id
    end
  end

  def self.down
    drop_table :activity_categories_branches
  end
end
