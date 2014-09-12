class Media < ActiveRecord::Base
  has_attached_file :media,
                    :url => "/uploads/:id_:style.:extension",
                    :path => ":rails_root/public/uploads/:id_:style.:extension"
                    
  validates :fb_id, :presence=>true, :uniqueness=>true, :if => Proc.new{|m| m.media_upload_type == "Facebook"}
  validates :media_type, :presence=>true
  validates_inclusion_of :media_type, :in => %w( photo video ), :if => Proc.new{|m| m.media_upload_type == "Facebook"}
  validates_inclusion_of :media_type, :in => %w( photo ), :if => Proc.new{|m| m.media_upload_type == "File"}
  validates_inclusion_of :media_upload_type, :in => %w( Facebook File )
  validates :media_file_name, :media_content_type, :media_file_size, :media_updated_at, :presence=>true, :if => Proc.new{|m| m.media_upload_type == "File"}
  
  has_and_belongs_to_many :activity_categories
  has_and_belongs_to_many :activities
  #has_and_belongs_to_many :articles
  has_and_belongs_to_many :branches
  scope :photos, where("media_type = 'photo'")
  scope :videos, where("media_type = 'video'")
  scope :facebook_files, where("media_upload_type = 'Facebook'")
  scope :files, where("media_upload_type = 'File'")
  scope :not_processed, where("processed = false")
  
  Media::PER_PAGE = 21
  
  def Media.find_or_create(fb_id , type='photo', thumb = nil)
    m = Media.find_by_fb_id(fb_id)
    return m  if m
    m = Media.create({:fb_id => fb_id, :media_type=> type, :thumbnail=> thumb})
    return m
  end
  
  def thumbnail_version(size = 'n')
    if self.thumbnail
      return self.thumbnail.sub(/_t.jpg$/,"_#{size}.jpg")
    end
    return "http://graph.facebook.com/#{self.fb_id}/picture"
  end
  
  def url
    if self.media_type == 'photo'
      if self.fb_id
        return self.thumbnail_version
      elsif self.media_upload_type == "File" 
        return "#{SITE_URL}#{self.media.url}"
      end
    end
  end
  
  def Media.construct_query(options = {})
    per_page = options[:per_page] ? options[:per_page].to_i : PER_PAGE
    query = ""
    case options[:media_type]
    when 'albums'
      query += "SELECT aid,object_id,name,link,created,size FROM album WHERE owner = '#{OMNIAUTH_CONFIG[:facebook]['facebook_page_id']}' ORDER BY created #{(options[:order]||'DESC').upcase }"
      
    when 'photos'
      query += "SELECT object_id,link,src_small,created,src_big,caption FROM photo "
      if options[:album_id]
        query += "WHERE aid='#{options[:album_id]}'"
      elsif options[:owner_id] && options[:owner_type] && (klass = owner_klass(options[:owner_type]))
        if !(instance = klass.find(options[:owner_id])).media.facebook_files.photos.empty?
          query += "WHERE object_id IN (#{instance.media.facebook_files.photos.collect(&:fb_id).join(',')})"
        else
          return ""
        end
      else
        query += "WHERE aid IN (SELECT aid FROM album WHERE owner = '#{OMNIAUTH_CONFIG[:facebook]['facebook_page_id']}')"
      end
      query += " ORDER BY object_id #{(options[:order]|| 'DESC').upcase }"
      
    when 'videos'
      query += "SELECT vid,title,embed_html,thumbnail_link,created_time,src,link FROM video "
      if options[:owner_id] && options[:owner_type] && (klass = owner_klass(options[:owner_type]))
        if !(instance = klass.find(options[:owner_id])).media.facebook_files.videos.empty?
          query += "WHERE vid IN (#{instance.media.facebook_files.videos.collect(&:fb_id).join(',')})"
        else
          return ""
        end
      else
        query += "WHERE owner = '#{OMNIAUTH_CONFIG[:facebook]['facebook_page_id']}'"
      end
      query += " ORDER BY created_time #{(options[:order]||'DESC').upcase }"
    else
      return ""
    end
    
    options[:page] = "1" if !options[:page]
    page = options[:page].to_i
    query += " LIMIT #{per_page + 1}"
    query += " OFFSET #{(page - 1) * per_page}" if options[:page]
    return query
  end
  
  private
  
  def Media.owner_klass(owner)
    case owner
    when 'activity'
      return ActivityCategory 
    when 'branch'
      return Branch
    when 'article'
      return Article
    end
  end
  
end
