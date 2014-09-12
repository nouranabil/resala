require 'spec_helper'

describe "admin/testimonials/index.html.erb" do
  before(:each) do
    assign(:estimonials, [
      stub_model(Testimonial,
        :title => "Title",
        :description => "Description",
        :source => "Source",
        :disclosure_date=>Time.now
      ),
      stub_model(Testimonial,
        :title => "Title",
        :description => "Description",
        :disclosure_date=>Time.now
      )
    ])
  end

  it "renders a list of admin/testimonials" do
    # render
    # # Run the generator again with the --webrat flag if you want to use webrat matchers
    # assert_select "tr>td", :text => "Title".to_s, :count => 2
    # # Run the generator again with the --webrat flag if you want to use webrat matchers
    # assert_select "tr>td", :text => "Description".to_s, :count => 2
    # # Run the generator again with the --webrat flag if you want to use webrat matchers
    # assert_select "tr>td", :text => "Source".to_s, :count => 2
    # # Run the generator again with the --webrat flag if you want to use webrat matchers
    # assert_select "tr>td", :text => "Url".to_s, :count => 2
  end
end
