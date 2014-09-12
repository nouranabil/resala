require 'spec_helper'

describe "admin/articles/new.html.erb" do
  before(:each) do
    assign(:article, stub_model(Article,
      :title => "MyString",
      :description => "MyString"
    ).as_new_record)
  end

  it "renders new article form" do
    # render
    # 
    # # Run the generator again with the --webrat flag if you want to use webrat matchers
    # assert_select "form", :action => admin_articles_path, :method => "post" do
    #   assert_select "input#article_title", :name => "article[title]"
    #   assert_select "input#article_description", :name => "article[description]"
    # end
  end
end
