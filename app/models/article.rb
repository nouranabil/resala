class Article < ActiveRecord::Base
  validates :title, :presence=>true, :length=>{:maximum=>250}
  validates :article_category_id, :presence=>true
  #validates :front_photo_id, :presence=>true
  belongs_to :article_category
  belongs_to :front_photo, :class_name => "Media"
  
  has_and_belongs_to_many :branches
  has_and_belongs_to_many :activity_categories
  has_and_belongs_to_many :media, :class_name=> 'Media'
  
  accepts_nested_attributes_for :branches, :reject_if => proc{|attrs| attrs.all? {|k, v| v.blank?}}
  accepts_nested_attributes_for :activity_categories, :reject_if => proc{|attrs| attrs.all? {|k, v| v.blank?}}
  
  scope :news, where(:article_category_id => ArticleCategory.news ? ArticleCategory.news.id : 0)
  scope :stories, where(:article_category_id => ArticleCategory.stories ? ArticleCategory.stories.id : 0)
  scope :related, lambda{|category_id, articles_ids, article_id|
    where("article_category_id = #{category_id} AND id in (#{(articles_ids << 0).join(',')}) AND id <> #{article_id}")
  }

  scope :latest, order("created_at desc")
  after_destroy :remove_facebook_post
  
  def self.per_page
    20
  end
  
  def front_photo_fb_id
    (photo = self.front_photo) ? photo.fb_id : nil
  end
  
  def remove_facebook_post
    if self.facebook_post_id.blank?
      return true
    else
      raise "not found" unless ProvidersShare.new().delete_share(self.facebook_post_id) 
      return true
    end
  end
  
  def front_photo_fb_id= fb_id
    self.front_photo = Media.find_by_fb_id fb_id
  end
    
  def increment_views_count
    self.update_attribute(:views_count, self.views_count.to_i + 1)
  end
  
  def related_articles(limit=5)
    Article.related(self.article_category_id, ActivityCategoriesArticle.articles(self.activity_categories.collect{|ac| ac.activity_category_id}).collect{|a| a.article_id}, self.id).latest.limit(limit)
  end
  
  def image_url
    return self.front_photo.url if self.front_photo 
    return self.media.first.url if !self.media.empty?
    return "#{SITE_URL}/images/fb_logo.png"
  end
  
  def album_id
    FACEBOOK_CONFIG[:wall_photos_id]
  end
  
  index do
    title
    description
  end
end
