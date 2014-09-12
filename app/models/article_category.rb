# -*- coding: utf-8 -*-
class ArticleCategory < ActiveRecord::Base
  validates :name, :presence=>true, :uniqueness=>true
  has_many :articles
  
  def self.news
    ArticleCategory.find_by_name(ArticleCategory.names[1])
  end
  
  def self.stories
    ArticleCategory.find_by_name(ArticleCategory.names[0])
  end
  
  def en_name
    return "stories" if name == ArticleCategory.names[0]
    return "news"
  end
  
  def self.names
    ["قصصنا","اخبار"]
  end
end