require 'spec_helper'

describe TestimonialsController do
  def valid_attributes
    {:title=>"new testimonial_#{Time.now.to_i}",
      :source=>"source",
      :disclosure_date=>Time.now}
  end
  
  describe "GET index" do
    it "assigns all testimonials as @testimonials" do
      testimonial = Testimonial.create! valid_attributes
      get :index
      assigns(:testimonials).should_not eq(nil)
    end
  end
  
  describe "GET show" do
    it "assigns the requested testimonial as @testimonial" do
      testimonial = Testimonial.create! valid_attributes
      get :show, :id => testimonial.id.to_s
      assigns(:testimonial).should eq(testimonial)
    end
  end
end