require 'spec_helper'

describe BranchesController do
  def valid_attributes
    {:name=>"new branch_#{Time.now.to_i}",
      :city=>City.create(:name=>"city_#{Time.now.to_i}"),
      :address=>"address"}
  end
  
  describe "GET index" do
    it "assigns all branches as @branches" do
      branch = Branch.create! valid_attributes
      get :index
      assigns(:branches).should_not eq(nil)
    end
  end
  
  describe "GET show" do
    it "assigns the requested article as @article" do
      branch = Branch.create! valid_attributes
      get :show, :id => branch.id.to_s
      assigns(:branch).should eq(branch)
    end
  end
end