require "spec_helper"

describe NewsletterSubscribersController do
  describe "routing" do
    it "routes to #create" do
      post("/newsletter_subscribers").should route_to("newsletter_subscribers#create")
    end
  end
end
