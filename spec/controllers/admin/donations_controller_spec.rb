require 'spec_helper'

describe Admin::DonationsController do
  before(:all) do
    @user = Factory(:admin_user)
  end
  
  def valid_attributes
    {:amount=>"123"}
  end
  
  describe "GET index" do
    it "assigns a donations as @donations" do
      login_user(request, @user)
      get :index
      assigns(:donations).should_not be(nil)
    end
  end
end