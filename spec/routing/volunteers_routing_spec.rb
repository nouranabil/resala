require "spec_helper"

describe VolunteersController do
  describe "routing" do
    it "routes to #new" do
      get("/volunteers/new").should route_to("volunteers#new")
    end
    
    it "routes to #create" do
      post("/volunteers").should route_to("volunteers#create")
    end
  end
end
