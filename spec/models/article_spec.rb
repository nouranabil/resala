require 'spec_helper'

describe Article do
  it "should be invalid without title" do
    Article.validate(:title).should have(1).errors_on(:title)
  end
  it "should be invalid without article_category_id" do
    Article.validate(:article_category_id).should have(1).errors_on(:article_category_id)
  end
end
