require 'spec_helper'

describe "admin/articles/index.html.erb" do
  before(:each) do
    assign(:articles, [
      stub_model(Article,
        :title => "Title",
        :description => "Description"
      ),
      stub_model(Article,
        :title => "Title",
        :description => "Description"
      )
    ])
  end

  it "renders a list of admin/articles" do
    # render
    # # Run the generator again with the --webrat flag if you want to use webrat matchers
    # assert_select "tr>td", :text => "Title".to_s, :count => 2
    # # Run the generator again with the --webrat flag if you want to use webrat matchers
    # assert_select "tr>td", :text => "Description".to_s, :count => 2
  end
end
