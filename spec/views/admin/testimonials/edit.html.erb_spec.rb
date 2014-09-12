require 'spec_helper'

describe "admin/testimonials/edit.html.erb" do
  before(:each) do
    @testimonial = assign(:testimonial, stub_model(Testimonial,
      :title => "MyString",
      :description => "MyString",
      :source => "MyString"
    ))
  end

  it "renders the edit testimonial form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    # assert_select "form", :action => admin_testimonials_path(@testimonial), :method => "post" do
    #   assert_select "input#testimonial_title", :name => "testimonial[title]"
    #   assert_select "input#testimonial_description", :name => "testimonial[description]"
    #   assert_select "input#testimonial_source", :name => "testimonial[source]"
    #   assert_select "input#testimonial_url", :name => "testimonial[url]"
    # end
  end
end
