require 'spec_helper'

describe NewsletterSubscribersController do
  def valid_attributes
    {:email=>"mostafa.ragab_#{Time.now.to_i}@espace.com.eg", 
     :name=>"mostafa_ragab_#{Time.now.to_i}"}
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new NewsletterSubscriber" do
        expect {
          post :create, :newsletter_subscriber => valid_attributes
        }.to change(NewsletterSubscriber, :count).by(1)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved newsletter_subscriber as @newsletter_subscriber" do
        NewsletterSubscriber.any_instance.stub(:save).and_return(false)
        post :create, :newsletter_subscriber => {}
        assigns(:newsletter_subscriber).should be_a_new(NewsletterSubscriber)
      end
    end
  end
end
