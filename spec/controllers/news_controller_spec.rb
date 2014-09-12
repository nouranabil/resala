require 'spec_helper'

describe NewsController do

  # This should return the minimal set of attributes required to create a valid
  # Article. As you add validations to Article, be sure to
  # update the return value of this method accordingly.
  def valid_attributes
    {:title=>"new article_#{Time.now.to_i}",
      :article_category_id=>ArticleCategory.last.id}
  end
  
  describe "GET index" do
    it "assigns all articles as @articles" do
      article = Article.create! valid_attributes
      get :index
      assigns(:articles).should_not eq(nil)
    end
  end
  
  describe "GET show" do
    # it "assigns the requested article as @article" do
    #   article = Article.create! valid_attributes
    #   get :show, :id => article.id.to_s
    #   assigns(:article).should eq(article)
    # end
  end
  
  describe "GET search" do
    it "assigns the requested articles as @articles" do
      article = Article.create! valid_attributes
      get :search, :id => article.id.to_s
      assigns(:articles).should_not eq(nil)
    end
  end
  
end