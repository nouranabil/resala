require 'spec_helper'

describe Admin::ArticlesController do
  before(:all) do
    @user = Factory(:admin_user)
  end
  
  def valid_attributes
    {:title=>"new article_#{Time.now.to_i}",
      :article_category_id=>ArticleCategory.first.id}
  end

  describe "GET index" do
    it "assigns all articles as @articles" do
      login_user(request, @user)
      article = Article.create! valid_attributes
      get :index
      assigns(:articles).should eq([article])
    end
  end

  describe "GET show" do
    it "assigns the requested article as @article" do
      login_user(request, @user)
      article = Article.create! valid_attributes
      get :show, :id => article.id.to_s
      assigns(:article).should eq(article)
    end
  end

  describe "GET new" do
    it "assigns a new article as @article" do
      login_user(request, @user)
      get :new
      assigns(:article).should be_a_new(Article)
    end
  end

  describe "GET edit" do
    it "assigns the requested article as @article" do
      login_user(request, @user)
      article = Article.create! valid_attributes
      get :edit, :id => article.id.to_s
      assigns(:article).should eq(article)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new Article" do
        login_user(request, @user)
        expect {
          post :create, :article => valid_attributes
        }.to change(Article, :count).by(1)
      end

      it "assigns a newly created article as @article" do
        login_user(request, @user)
        post :create, :article => valid_attributes
        assigns(:article).should be_a(Article)
        assigns(:article).should be_persisted
      end

      it "redirects to the created article" do
        login_user(request, @user)
        post :create, :article => valid_attributes
        response.should redirect_to(admin_articles_path)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved article as @article" do
        login_user(request, @user)
        # Trigger the behavior that occurs when invalid params are submitted
        Article.any_instance.stub(:save).and_return(false)
        post :create, :article => {}
        assigns(:article).should be_a_new(Article)
      end

      it "re-renders the 'new' template" do
        login_user(request, @user)
        # Trigger the behavior that occurs when invalid params are submitted
        Article.any_instance.stub(:save).and_return(false)
        post :create, :article => {}
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested article" do
        login_user(request, @user)
        article = Article.create! valid_attributes
        # Assuming there are no other articles in the database, this
        # specifies that the Article created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        Article.any_instance.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => article.id, :article => {'these' => 'params'}
      end

      it "assigns the requested article as @article" do
        login_user(request, @user)
        article = Article.create! valid_attributes
        put :update, :id => article.id, :article => valid_attributes
        assigns(:article).should eq(article)
      end

      it "redirects to the article" do
        login_user(request, @user)
        article = Article.create! valid_attributes
        put :update, :id => article.id, :article => valid_attributes
        response.should redirect_to(admin_articles_path+"?page=1")
      end
    end

    describe "with invalid params" do
      it "assigns the article as @article" do
        login_user(request, @user)
        article = Article.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Article.any_instance.stub(:save).and_return(false)
        put :update, :id => article.id.to_s, :article => {}
        assigns(:article).should eq(article)
      end

      it "re-renders the 'edit' template" do
        login_user(request, @user)
        article = Article.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Article.any_instance.stub(:save).and_return(false)
        put :update, :id => article.id.to_s, :article => {}
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested article" do
      login_user(request, @user)
      article = Article.create! valid_attributes
      expect {
        delete :destroy, :id => article.id.to_s
      }.to change(Article, :count).by(-1)
    end

    it "redirects to the articles list" do
      login_user(request, @user)
      article = Article.create! valid_attributes
      delete :destroy, :id => article.id.to_s
      response.should redirect_to(admin_articles_url+"?page=1")
    end
  end

end
