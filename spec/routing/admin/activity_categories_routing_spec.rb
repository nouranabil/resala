require "spec_helper"

describe Admin::ActivityCategoriesController do
  describe "routing" do

    it "routes to #index" do
      get("/admin/activity_categories").should route_to("admin/activity_categories#index")
    end

    it "routes to #new" do
      get("/admin/activity_categories/new").should route_to("admin/activity_categories#new")
    end

    it "routes to #show" do
      get("/admin/activity_categories/1").should route_to("admin/activity_categories#show", :id => "1")
    end

    it "routes to #edit" do
      get("/admin/activity_categories/1/edit").should route_to("admin/activity_categories#edit", :id => "1")
    end

    it "routes to #create" do
      post("/admin/activity_categories").should route_to("admin/activity_categories#create")
    end

    it "routes to #update" do
      put("/admin/activity_categories/1").should route_to("admin/activity_categories#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/admin/activity_categories/1").should route_to("admin/activity_categories#destroy", :id => "1")
    end

  end
end
