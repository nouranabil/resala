require "spec_helper"

describe ActivitiesController do
  describe "routing" do
    it "routes to #new" do
      get("/activities/new").should route_to("activities#new")
    end

    it "routes to #create" do
      post("/activities").should route_to("activities#create")
    end
  end
end
