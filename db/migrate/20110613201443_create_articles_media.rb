class CreateArticlesMedia < ActiveRecord::Migration
  def self.up
    create_table :articles_media, :id=> false  do |t|
      t.integer :article_id
      t.integer :media_id
    end
  end

  def self.down
    drop_table :articles_media
  end
end
