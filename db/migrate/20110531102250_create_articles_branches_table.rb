class CreateArticlesBranchesTable < ActiveRecord::Migration
  def self.up
    create_table :articles_branches, :id=> false  do |t|
      t.integer :article_id
      t.integer :branch_id
    end
  end
  
  def self.down
    drop_table :articles_branches
  end
end