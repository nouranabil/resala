require 'spec_helper'
describe ActivitiesController do
  def valid_attributes
    {:title=>"activity title",
     :description=>"activity description",
     :required_volunteers_count=>"3"}
  end
  
  before :all do
    @user = Factory(:volunteer_can_create_activity)
    @activity_category = ActivityCategory.create(:name=>"activity_#{Time.now.to_i}", :front_photo_id=>"123", :short_description=>"short_description")
  end

  describe "GET new" do
    it "assigns a new activity as @activity" do
      login_user(request, @user)
      get :new
      assigns(:activity).should be_a_new(Activity)
    end
  end
  
  describe "GET show" do
    it "assigns an activity as @activity" do
      activity = Activity.new valid_attributes
      activity.activity_categories = [@activity_category]
      activity.save 
      get :show , :id =>  activity.id
      # assigns(:activity).should be_a_new(Activity)
    end
  end
  
  describe "POST create" do
    describe "with valid params" do
      it "creates a new Activity" do
        login_user(request, @user)
        expect {
          post :create, :activity => valid_attributes, :activity_categories=>[@activity_category.id]
        }.to change(Activity, :count).by(1)
      end

      it "assigns a newly created activity as @activity" do
        login_user(request, @user)
        post :create, :activity => valid_attributes, :activity_categories=>[@activity_category.id]
        assigns(:activity).should be_a(Activity)
      end

      it "redirects to the created activity" do
        login_user(request, @user)
        post :create, :activity => valid_attributes, :activity_categories=>[@activity_category.id]
        response.should redirect_to(dashboard_volunteer_path(@user))
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved activity as @activity" do
        login_user(request, @user)
        Activity.any_instance.stub(:save).and_return(false)
        post :create, :activity => {}
        assigns(:activity).should be_a_new(Activity)
      end

      it "re-renders the 'new' template" do
        login_user(request, @user)
        Activity.any_instance.stub(:save).and_return(false)
        post :create, :activity => {}
        response.should render_template("new")
      end
    end
  end
  
  describe "post quit" do
    describe "when user is subscribed in the activity" do
      # it "quits user from the activity" do
      #   activity = Activity.new valid_attributes
      #   activity.activity_categories = [@activity_category]
      #   activity.save
      #   volunteer = Factory(:volunteer)
      #   ar = ActivitiesRequest.create({:activity=>activity, :volunteer=>volunteer, :status=> 2})
      #   activity.volunteers.to_a.should include(volunteer)
      #   post :quit , :id =>  activity.id
      #   activity.volunteers.to_a.should_not include(volunteer)
      # end
    end
  end
end