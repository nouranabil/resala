class TestimonialsController < ApplicationController
  caches_action :show, :layout=>true, :expires_in=>CACHE_EXPIRES_IN.call, :if => Proc.new{|x| params[:legacy].blank? }
  caches_action :index, :layout=>true, :cache_path => :cache_path.to_proc, :expires_in=>CACHE_EXPIRES_IN.call
  
  def show
    unless params[:legacy].blank?
      @testimonial = Testimonial.find_by_legacy_id!(params[:id])
      redirect_to @testimonial
      return
    end  
    @testimonial = Testimonial.find params[:id]
  end
  
  def index
    @testimonials = Testimonial.latest
    @testimonials = @testimonials.paginate(:page => params[:page], :per_page=>Testimonial.per_page)
  end
  
  def cache_path
    { :page => params[:page] || 1 }
  end
end
