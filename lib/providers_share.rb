# -*- coding: utf-8 -*-
class ProvidersShare
  include ActionView::Helpers::TextHelper
  
  def initialize(article=nil, by_admin = true, user=nil, activity=nil, message="")
    if by_admin
      @user = User.where(:facebook_page_admin=>true).first
      @article = article if article
    elsif user
      @user = user
    end
    
    @activity = activity if activity
    @message = message
    @accesstoken = OMNIAUTH_CONFIG[:facebook]["page_token"]
    @logger = Rails.logger
  end
  
  def share
    facebook_share
  end
  
  def volunteer_share
    raise "بيانات المتطوع غير صحيحة" unless @user
    old_facebook_share(link=get_full_url("/activities"), name="تطوعت بجمعية رسالة الخيرية", description="لقد قمت بالتطوع بجمعية رسالة في الأعمال الخيرية التالية  : #{@user.activity_categories.collect{|ac| ac.name}.join(', ')}", picture=get_full_url("/images/fb_logo.png"), "/me/feed", message="لقد تطوعت بجمعية رسالة الخيرية، للتطوع، قم بزيارة \n#{link}")
  end
  
  def activity_share
    facebook_share(link=get_full_url("/activities/#{@activity.id}"), name=@activity.title, description=@activity.description, picture = activity_image, post_to="/#{OMNIAUTH_CONFIG[:facebook]['facebook_page_id']}/feed", message = @activity.facebook_post_message || "")
  end
  
  def close_activity_share
    facebook_share(link=get_full_url("/activities/#{@activity.id}"), name="تم بحمد الله : #{@activity.title}", description=@activity.description, picture = activity_image, "/#{OMNIAUTH_CONFIG[:facebook]['facebook_page_id']}/feed", message = @activity.facebook_post_message || "")
  end
  
  def activity_join_share
    raise "بيانات المتطوع غير صحيحة" unless @user
    old_facebook_share(link=get_full_url("/activities/#{@activity.id}"), name="اشتركت بالعمل التطوعي : #{@activity.title}", description="لقد قمت بالاشتراك في العمل التطوعي '#{@activity.title}' بجمعية رسالة", picture=get_full_url("/images/fb_logo.png"), "/me/feed", message="لقد قمت بالاشتراك في العمل التطوعي '#{@activity.title}' بجمعية رسالة، للتطوع، قم بزيارة \n#{link}")
  end
  
  def delete_share(facebook_post_id)
    delete_facebook_share(facebook_post_id)
  end
  
  #######
  private
  #######
  
  def article_url
    "#{SITE_URL}/#{@article.article_category.en_name}/#{@article.id}"
  end
  
  def get_full_url(path)
    "#{SITE_URL}#{path}"
  end
  
  def article_description
    desc = strip_tags(@article.description)
    desc.blank? ? "" : truncate(desc, :length=>200, :omission=>" ... ")
  end
  
  def article_image
    front_photo = @article.front_photo ? @article.front_photo : @article.media.facebook_files.photos.first
    src = front_photo ? (front_photo.thumbnail ? front_photo.thumbnail : "http://graph.facebook.com/#{front_photo.fb_id}/picture") : get_full_url("/images/fb_logo.png")
    shorten_url(src)
  end
  
  def activity_image
    front_photo = @activity.front_photo ? @activity.front_photo : nil
    src = get_full_url("/images/fb_logo.png")
    if front_photo
      src = front_photo.url
    end
    return src
  end
  
  def delete_facebook_share(facebook_post_id)
    begin
      post = FbGraph::Post.new(facebook_post_id).fetch(:access_token => @accesstoken)
      post.destroy(:access_token => @accesstoken)
      return post
    rescue => e
      @logger.debug e.message
      return false
    end
  end
  
  def shorten_url(url)
    bitly = Bitly.new('o_5advu7033s','R_11d85a5706a1bfe49d3c264643b775ed')
    page_url = bitly.shorten(url)
    return page_url.shorten
  end
  
  def facebook_get_page
    page = FbGraph::Page.fetch(OMNIAUTH_CONFIG[:facebook]["facebook_page_id"])
    return page
  end
  
  def old_facebook_share(link=article_url, name=@article.title, description=article_description, picture=article_image, post_to="/#{OMNIAUTH_CONFIG[:facebook]['facebook_page_id']}/feed", message=nil)
    client = OAuth2::Client.new(OMNIAUTH_CONFIG[:facebook]["key"], OMNIAUTH_CONFIG[:facebook]["secret"], {:site => 'https://graph.facebook.com/'})
    accesstoken = OAuth2::AccessToken.new(client, @user.provider_token)
    
    begin
      @facebook_response = accesstoken.post(post_to, {
        :link => link,
        :name => name,
        :description => description,
        :picture => picture,
        :message => message
      })
    rescue => e
      puts " > > > facebook error : #{e.message}"
      @logger.debug " > > > facebook error : #{e.message}"
      raise "لا يمكن العثور على صلاحية للنشر على فيسبوك"
    end
    
    if @facebook_response.nil?
      @logger.debug "حدث خطأ ما اثناء النشر على فيسبوك"
      raise "حدث خطأ ما اثناء النشر على فيسبوك"
    else
      post_id = JSON.parse(@facebook_response)["id"]
      @article.update_attribute(:facebook_post_id, post_id) if @article
    end
  end
  
  def facebook_share(link=article_url, name=@article.title, description=article_description, picture=article_image, post_to="/#{OMNIAUTH_CONFIG[:facebook]['facebook_page_id']}/feed", message="")
    begin
      page = facebook_get_page
      x= "http://www.facebook.com/sharer.php?u=#{link}&t=#{name}"
      #y= "#{SITE_URL}/login/facebook?action_after_login=/activities/#{@activity.id}/join_activity"
      #actions = [{'name'=>'Share','link'=>x},{'name'=>'Join','link'=>y}]
      #http://apps.facebook.com/widgadget/share/share/pubid/293421172784011501/wid/16671?fb_force_mode=iframe&ref=nf
      #http://www.facebook.com/dialog/feed?display=popup&app_id=123050457758183&%20%20link=http://developers.facebook.com/docs/reference/dialogs/&%20%20picture=http://fbrell.com/f8.jpg&%20%20name=Facebook%20Dialogs&%20%20caption=Reference%20Documentation&%20%20description=Using%20Dialogs%20to%20interact%20with%20users.&%20%20message=Facebook%20Dialogs%20are%20so%20easy!&%20%20redirect_uri=http://www.example.com/response
      #"http://www.facebook.com/dialog/feed?app_id=#{FACEBOOK_CONFIG[:app_id]}&picture=#{picture}&name=#{name}&description=#{description}&message=#{message}&link=#{link}&redirect_uri=#{SITE_URL}&display=page"
      @facebook_response = page.feed!(:message      => message,
                                      :access_token => @accesstoken,
                                      :link         => link,
                                      :name         => name,
                                      :description  => description,
                                      :actions      => [{'name'=>'Share','link'=>x}],
                                      :picture      => picture)
                                      
    rescue => e
      puts " > > > facebook error : #{e.message}"
      @logger.debug " > > > facebook error : #{e.message}"
      raise "لا يمكن النشر على فيسبوك"
    end
    
    if @facebook_response.nil?
      @logger.error "حدث خطأ ما اثناء النشر على فيسبوك"
      raise "حدث خطأ ما اثناء النشر على فيسبوك"
    else
      post_id = @facebook_response.identifier
      @article.update_attribute(:facebook_post_id, post_id) if @article
    end
  end
end