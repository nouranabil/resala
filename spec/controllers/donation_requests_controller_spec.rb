require 'spec_helper'
describe DonationRequestsController do
  def valid_attributes
    {:name=>"mostafa",
      :address=>"alex",
      :mobile=>"0123456789",
      :amount=>"12",
      :amount_period=>"month",
      :city=>City.create(:name=>"city_#{Time.now.to_i}")}
  end
  
  describe "GET new" do
    it "assigns a new donation_request as @donation_request" do
      get :new
      assigns(:donation_request).should be_a_new(DonationRequest)
    end
  end
  
  describe "POST create" do
    describe "with valid params" do
      it "creates a new DonationRequest" do
        expect {
          post :create, :donation_request => valid_attributes
        }.to change(DonationRequest, :count).by(1)
      end

      it "assigns a newly created donation_request as @donation_request" do
        post :create, :donation_request => valid_attributes
        assigns(:donation_request).should be_a(DonationRequest)
        assigns(:donation_request).should be_persisted
      end

      it "redirects to the created donation_request" do
        post :create, :donation_request => valid_attributes
        response.should redirect_to(root_path)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved donation_request as @donation_request" do
        # Trigger the behavior that occurs when invalid params are submitted
        DonationRequest.any_instance.stub(:save).and_return(false)
        post :create, :donation_request => {}
        assigns(:donation_request).should be_a_new(DonationRequest)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        DonationRequest.any_instance.stub(:save).and_return(false)
        post :create, :donation_request => {}
        response.should render_template("new")
      end
    end
  end
end
