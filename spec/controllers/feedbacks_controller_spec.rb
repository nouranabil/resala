require 'spec_helper'

describe FeedbacksController do
  def valid_attributes
    {:email=>"mostafa.ragab@espace.com.eg", 
      :title=>"title", :body=>"body"}
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new FeedbacksController" do
        post :create, :feedback => valid_attributes
        response.status.should be(302)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved feedback as @feedback" do
        FeedbacksController.any_instance.stub(:save).and_return(false)
        post :create, :feedback => {}
        assigns(:feedback).should_not be(nil)
      end
    end
  end
end