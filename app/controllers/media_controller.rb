class MediaController < ApplicationController
  
  def index
    @media_type = params[:media_type] || 'photos'
    @page = params[:page] ? params[:page].to_i : 1
    @query = Media.construct_query(params)
    
    respond_to do |format|
      format.html do
        if params[:media_picker]
          render 'media_picker',:layout=> false
        end
      end
      format.js
    end
  end
  
  def show
    @media_type = params[:media_type].singularize
    if @media_type == 'photo'
      @query = "SELECT object_id,link,created,src_big,caption FROM photo WHERE object_id = '#{params[:fb_id]}'"
    elsif @media_type == 'video'
      @query = "SELECT vid,title,embed_html,thumbnail_link,created_time,src,link FROM video WHERE vid = '#{params[:fb_id]}'"
    end
    @media_info = Media.find_by_fb_id(params[:fb_id])
    
    render :show, :layout => params[:layout]!='false'
  end
  
end
