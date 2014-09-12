require 'spec_helper'

describe VolunteersController do
  def valid_attributes
    {:provider=>"facebook",
     :uid=>"123",
     :provider_token=>"123",
     :name=>"Mostafa Ragab",
     :email=>"mostafa.ragab@espace.com.eg", 
     :gender=>"M", :date_of_birth=>30.years.ago, 
     :branch_id=>Branch.create(:name=>"alex_#{Time.now.to_i}", :city_id=>City.create(:name=>"alex_#{Time.now.to_i}").id, :address=>"alex and ria").id,
     :mobile=>"0123456789", 
     :university=>"alex", 
     :post_updates_to_facebook=>false}
  end
  
  describe "GET new" do
    it "assigns a new volunteer as @volunteer" do
      get :new
      assigns(:volunteer).should be_a_new(Volunteer)
    end
  end
  
  describe "GET index" do
    it "assigns all volunteers as @volunteers" do
      volunteer = Volunteer.create! valid_attributes.merge(:activity_categories=>[ActivityCategory.create(:name=>"activity_#{Time.now.to_i}", :front_photo_id=>"123", :short_description=>"short_description")])
      get :index
      assigns(:volunteers).should_not eq(nil)
    end
  end
  
  describe "GET edit" do
    it "assigns volunteer as @volunteer" do
      volunteer = Volunteer.create! valid_attributes.merge(:activity_categories=>[ActivityCategory.create(:name=>"activity_#{Time.now.to_i}", :front_photo_id=>"123", :short_description=>"short_description")])
      @user = Factory(:volunteer)
      login_user(request, @user)
      get :edit, :id=>@user.id
      assigns(:volunteer).should be_a(Volunteer)
    end
  end
  
  describe "GET show" do
    it "assigns volunteer as @volunteer" do
      volunteer = Volunteer.create! valid_attributes.merge(:activity_categories=>[ActivityCategory.create(:name=>"activity_#{Time.now.to_i}", :front_photo_id=>"123", :short_description=>"short_description")])
      @user = Factory(:volunteer)
      login_user(request, @user)
      get :show, :id=>@user.id
      assigns(:volunteer).should be_a(Volunteer)
    end
  end
  
  describe "POST create" do
    describe "with valid params" do
      it "creates a new volunteer" do
        expect {
          post :create, :volunteer => valid_attributes, :activity_categories =>[ActivityCategory.create(:name=>"activity_#{Time.now.to_i}", :front_photo_id=>"123", :short_description=>"short_description").id]
        }.to change(Volunteer, :count).by(1)
      end

      it "assigns a newly created volunteer as @volunteer" do
        post :create, :volunteer => valid_attributes, :activity_categories =>[ActivityCategory.create(:name=>"activity_#{Time.now.to_i}", :front_photo_id=>"123", :short_description=>"short_description").id]
        assigns(:volunteer).should be_a(Volunteer)
        assigns(:volunteer).should be_persisted
      end

      it "redirects to the created volunteer" do
        post :create, :volunteer => valid_attributes, :activity_categories =>[ActivityCategory.create(:name=>"activity_#{Time.now.to_i}", :front_photo_id=>"123", :short_description=>"short_description").id]
        response.should redirect_to(gateway_volunteers_path)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved volunteer as @volunteer" do
        Volunteer.any_instance.stub(:save).and_return(false)
        post :create, :volunteer => {}
        assigns(:volunteer).should be_a_new(Volunteer)
      end

      it "re-renders the 'new' template" do
        Volunteer.any_instance.stub(:save).and_return(false)
        post :create, :volunteer => {}
        response.should render_template("new")
      end
    end
  end
  
  describe "POST update" do
    describe "with valid params" do
      it "assigns a volunteer as @volunteer" do
        @user = Factory(:volunteer)
        login_user(request, @user)
        put :update, :id => @user.id, :volunteer => valid_attributes.merge(:name=>"test update"), :activity_categories =>[ActivityCategory.create(:name=>"activity_#{Time.now.to_i}", :front_photo_id=>"123", :short_description=>"short_description").id]
        assigns(:volunteer).should be_a(Volunteer)
        assigns(:volunteer).name.should eq("test update")
      end

      it "redirects to the updated volunteer" do
        @user = Factory(:volunteer)
        login_user(request, @user)
        put :update, :id => @user.id, :volunteer => valid_attributes, :activity_categories =>[ActivityCategory.create(:name=>"activity_#{Time.now.to_i}", :front_photo_id=>"123", :short_description=>"short_description").id]
        response.should redirect_to(volunteer_path(@user.id))
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved volunteer as @volunteer" do
        Volunteer.any_instance.stub(:save).and_return(false)
        @user = Factory(:volunteer)
        login_user(request, @user)
        put :update, :id => @user.id, :volunteer => {:name=>nil}
        assigns(:volunteer).id.should eq(@user.id)
      end

      it "re-renders the 'new' template" do
        Volunteer.any_instance.stub(:save).and_return(false)
        @user = Factory(:volunteer)
        login_user(request, @user)
        put :update, :id => @user.id, :volunteer => {:name=>nil}
        response.should render_template("edit")
      end
    end
  end
  
  describe "POST activities_authority request" do
    describe "with valid params" do
      it "update activities_authority" do
        @user = Factory(:volunteer)
        login_user(request, @user)
        post :activities_authority
        User.find(@user.id).activities_authority_status.should eq(ActivitiesAuthorityStatus.requested) 
      end
    end
  end
end