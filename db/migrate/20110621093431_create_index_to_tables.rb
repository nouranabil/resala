class CreateIndexToTables < ActiveRecord::Migration
  def self.up
    add_index :articles, :article_category_id
    add_index :activity_categories_articles, :activity_category_id
    add_index :activity_categories_articles, :article_id
    add_index :article_categories, :name
    add_index :branches, :city_id
    add_index :activity_categories_branches, :branch_id
    add_index :media, :media_type
    add_index :activity_categories_media, :activity_category_id
    add_index :articles_media, :article_id
    add_index :branches_media, :branch_id
  end

  def self.down
    remove_index :articles, :article_category_id
    remove_index :activity_categories_articles, :activity_category_id
    remove_index :activity_categories_articles, :article_id
    remove_index :article_categories, :name
    remove_index :branches, :city_id
    remove_index :activity_categories_branches, :branch_id
    remove_index :media, :media_type
    remove_index :activity_categories_media, :activity_category_id
    remove_index :articles_media, :article_id
    remove_index :branches_media, :branch_id
  end
end