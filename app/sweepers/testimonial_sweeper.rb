class TestimonialSweeper < Sweeper
  observe Testimonial
  
  def after_update(testimonial)
    expire_action_cache_for("testimonials", "show", testimonial.id) if testimonial.changed?
    if first_testimonials_page(testimonial).collect{|t| t.id}.include?(testimonial.id)
      expire_action_cache_for("testimonials", "index", nil,  1)
    end
  end
  
  def after_create(testimonial)
    expire_action_cache_for("testimonials", "index", nil,  first_testimonials_page(testimonial).total_pages)
  end
  
  def after_destroy(testimonial)
    expire_action_cache_for("testimonials", "index", nil,  first_testimonials_page(testimonial).total_pages)
  end
  #######
  private
  #######
  
  def first_testimonials_page(testimonial)
    @testimonials || @testimonials =  Testimonial.latest.paginate(:page => 1, :per_page=>Testimonial.per_page)
  end
end