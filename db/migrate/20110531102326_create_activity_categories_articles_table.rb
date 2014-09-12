class CreateActivityCategoriesArticlesTable < ActiveRecord::Migration
  def self.up
    create_table :activity_categories_articles, :id=> false  do |t|
      t.integer :activity_category_id
      t.integer :article_id
    end
  end

  def self.down
    drop_table :activity_categories_articles
  end
end
