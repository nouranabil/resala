require 'spec_helper'

describe PagesController do
  describe "User, " do
    it "renders home page" do
      get :show, :id=> :home
      response.should be_success
      response.should render_template("home")
    end
    it "renders about page" do
      get :show, :id=> :about
      response.should be_success
      response.should render_template("about")
    end
    it "renders achievements page" do
      get :show, :id=> :achievements
      response.should be_success
      response.should render_template("achievements")
    end
    it "renders history page" do
      get :show, :id=> :history
      response.should be_success
      response.should render_template("history")
    end
    it "renders mission page" do
      get :show, :id=> :mission
      response.should be_success
      response.should render_template("mission")
    end
  end
end