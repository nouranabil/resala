require 'spec_helper'

describe Admin::DonationRequestsController do
  before(:all) do
    @user = Factory(:admin_user)
  end
  
  def valid_attributes
    {:name=>"mostafa",
      :address=>"alex",
      :mobile=>"0123456789",
      :amount=>"12",
      :amount_period=>"month",
      :city=>City.create(:name=>"city_#{Time.now.to_i}")}
  end
  
  describe "GET index" do
    it "assigns a donation requests as @donation_requests" do
      login_user(request, @user)
      get :index
      assigns(:donation_requests).should_not be(nil)
    end
  end
  
  describe "GET show" do
    it "assigns the requested donation_request as @donation_request" do
      login_user(request, @user)
      donation_request = DonationRequest.create! valid_attributes
      get :show, :id => donation_request.id.to_s
      assigns(:donation_request).should eq(donation_request)
    end
  end
  
  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested donation_request" do
        login_user(request, @user)
        donation_request = DonationRequest.create! valid_attributes
        put :update, :id => donation_request.id, :reviewed => "true"
      end

      it "assigns the requested donation_request as @donation_request" do
        login_user(request, @user)
        donation_request = DonationRequest.create! valid_attributes
        donation_request.reviewed = false
        put :update, :id => donation_request.id, :reviewed => "true"
        assigns(:donation_request).reviewed.should eq(true)
      end
    end
  end
  
  describe "DELETE destroy" do
    it "destroys the donation_request" do
      login_user(request, @user)
      donation_request = DonationRequest.create! valid_attributes
      expect {
        delete :destroy, :id => donation_request.id.to_s
      }.to change(DonationRequest, :count).by(-1)
    end

    it "redirects to the donation_request list" do
      login_user(request, @user)
      donation_request = DonationRequest.create! valid_attributes
      delete :destroy, :id => donation_request.id.to_s
      response.should redirect_to(admin_donation_requests_path+"?page=1")
    end
  end
end