require 'spec_helper'

describe Admin::NewsletterSubscribersController do
  before(:all) do
    @user = Factory(:admin_user)
  end
  
  def valid_attributes
    {:email=>"mostafa_#{Time.now.to_i}@espace.com.eg",
     :name=>"mostafa_ragab_#{Time.now.to_i}"}
  end

  describe "GET index" do
    it "assigns all newsletter_subscribers as @newsletter_subscribers" do
      login_user(request, @user)
      newsletter_subscriber = NewsletterSubscriber.create! valid_attributes
      get :index
      assigns(:newsletter_subscribers).should eq([newsletter_subscriber])
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested newsletter_subscriber" do
      login_user(request, @user)
      newsletter_subscriber = NewsletterSubscriber.create! valid_attributes
      expect {
        delete :destroy, :id => newsletter_subscriber.id.to_s
      }.to change(NewsletterSubscriber, :count).by(-1)
    end

    it "redirects to the newsletter_subscribers list" do
      login_user(request, @user)
      newsletter_subscriber = NewsletterSubscriber.create! valid_attributes
      delete :destroy, :id => newsletter_subscriber.id.to_s
      response.should redirect_to(admin_newsletter_subscribers_url+"?page=1")
    end
  end

end
