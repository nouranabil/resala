class CreateArticles < ActiveRecord::Migration
  def self.up
    create_table :articles do |t|
      t.string :title
      t.string :description
      t.integer :article_category_id

      t.timestamps
    end
  end

  def self.down
    drop_table :articles
  end
end
