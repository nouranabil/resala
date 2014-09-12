require 'spec_helper'

describe "admin/testimonials/show.html.erb" do
  before(:each) do
    @testimonial = assign(:testimonial, stub_model(Testimonial,
      :title => "Title",
      :description => "Description",
      :source => "Source"
    ))
  end

  it "renders attributes in <p>" do
    # render
    # # Run the generator again with the --webrat flag if you want to use webrat matchers
    # rendered.should match(/Title/)
    # # Run the generator again with the --webrat flag if you want to use webrat matchers
    # rendered.should match(/Description/)
    # # Run the generator again with the --webrat flag if you want to use webrat matchers
    # rendered.should match(/Source/)
    # # Run the generator again with the --webrat flag if you want to use webrat matchers
    # rendered.should match(/Url/)
  end
end
