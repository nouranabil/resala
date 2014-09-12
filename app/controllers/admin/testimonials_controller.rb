class Admin::TestimonialsController < Admin::AdminController
  before_filter :handle_media_list, :only=>[:create,:update]
  cache_sweeper :testimonial_sweeper, :only=>[:create, :update, :destroy]
  
  def index
    @testimonials = Testimonial.order("created_at desc").paginate(:page => params[:page], :per_page=>Testimonial.per_page)
  end

  def show
    @testimonial = Testimonial.find(params[:id])
  end
  
  def new
    @testimonial = Testimonial.new
  end

  def edit
    params[:page] ||= 1
    @testimonial = Testimonial.find(params[:id])
  end

  def create
    @testimonial = Testimonial.new(params[:testimonial])

    if @testimonial.save
      redirect_to(admin_testimonial_path(@testimonial), :notice => t("messages.saved", :name => t("testimonial.testimonial")))
    else
      render :action => "new"
    end
  end
  
  def update
    @testimonial = Testimonial.find(params[:id])
    params[:page] ||= 1
    
    if @testimonial.update_attributes(params[:testimonial])
      redirect_to(admin_testimonial_path(@testimonial, :page=>params[:page] ||= 1), :notice => t("messages.saved", :name => t("testimonial.testimonial")))
    else
      render :action => "edit"
    end
  end

  def destroy
    @testimonial = Testimonial.find(params[:id])
    @testimonial.destroy
    params[:page] ||= 1
    redirect_to admin_testimonials_path(:page=>params[:page])
  end
  
  #######
  private
  #######
  
  def handle_media_list
    begin
      if(params[:testimonial][:photo])
        media_list = ActiveSupport::JSON.decode(params[:testimonial][:photo])
        media_list = media_list.collect{|m| Media.find_or_create(m['id'] , m['mediaType'], m['thumbnail'])}
        params[:testimonial][:photo] = media_list.first
      end
    rescue
      raise "JSON parsing failed"
    end
  end
end
