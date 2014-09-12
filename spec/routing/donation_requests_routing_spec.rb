require "spec_helper"

describe DonationRequestsController do
  describe "routing" do
    it "routes to #new" do
      get("/donation_requests/new").should route_to("donation_requests#new")
    end

    it "routes to #create" do
      post("/donation_requests").should route_to("donation_requests#create")
    end
  end
end
