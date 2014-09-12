# -*- coding: utf-8 -*-
class FilesUpload
  def initialize(article = nil, activity = nil, share_to_facebook = false)
    @article = nil
    @activity = nil
    
    @article = article if article
    @activity = activity if activity
    @share_to_facebook = share_to_facebook
    
    if @article
      @media_list = @article.media.files.not_processed
    elsif @activity
      @album_title = @activity.title 
      @media_list = @activity.media.files.not_processed
      #@activity.media << @activity.front_photo if @activity.front_photo &&  !@activity.front_photo.processed #Activity front photo will remain hosted on resala
    end
     
    @accesstoken = OMNIAUTH_CONFIG[:facebook]["page_token"]
  end
  
  def upload
    raise "لا توجد ملفات" if @article.nil? && @activity.nil?
    raise "لا توجد ملفات، يجب اختيار ملفات ليتم رفعها على الفيسبوك" unless @media_list
    
    should_remove_post = false
    if @media_list.photos.size > 0
      should_remove_post = true
      parent = @article || @activity 
      if ! parent.album_id
        album = facebook_create_album(@album_title)
        parent.album_id = album.identifier
        parent.save
      else
        album = FbGraph::Album.fetch(parent.album_id)
      end
    end
    page = facebook_get_page if @media_list.videos.size > 0
    
    #raise "لا يمكن إنشاء البوم جديد" unless album && page
    
    @media_list.each do |media|
      begin
        if media.media_type.pluralize == "photos"
          media_file = album.photo!(
            :access_token => @accesstoken,
            :source => File.new(media.media.path, 'rb'),
            :message => nil
          )
        else
          media_file = page.video!(
            :access_token => @accesstoken,
            :source => File.new(media.media.path, 'rb'),
            :message => nil
          )
        end
        
        media.media = nil
        media.attributes = {:fb_id => media_file.identifier, :processed => true, :media_upload_type => "Facebook"}
        media.save!
      rescue => e
        raise e
      end
    end
    
    ProvidersShare.new(@article).share if @article && @share_to_facebook
    remove_posts(parent) if should_remove_post
    
  end
  
  def remove_posts(parent ,limit = 10)
    puts "removing post"
    page = facebook_get_page
    posts = page.posts(:access_token=> OMNIAUTH_CONFIG[:facebook]["page_token"], :limit=>limit)
    posts.each do |post|
      if post.type == "photo"
        post.destroy(:access_token=> OMNIAUTH_CONFIG[:facebook]["page_token"])
        #puts "removed the automatic image notification post"
        break;
      end
    end
    return page
  end
  
  #######
  private
  #######
  
  def facebook_get_page
    page = FbGraph::Page.fetch(OMNIAUTH_CONFIG[:facebook]["facebook_page_id"])
    return page
  end
  
  def facebook_create_album(name, message = nil)
    page = facebook_get_page
    album = page.album!(
      :access_token => @accesstoken,
      :name => name,
      :message => message
    ) 
    return album
  end
end