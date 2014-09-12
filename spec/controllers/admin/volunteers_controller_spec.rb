require 'spec_helper'

describe Admin::VolunteersController do
  before(:all) do
    @user = Factory(:admin_user)
  end
  
  def valid_attributes
    {:provider=>"facebook",
     :uid=>"123",
     :provider_token=>"123",
     :name=>"Mostafa Ragab",
     :email=>"mostafa.ragab@espace.com.eg", 
     :gender=>"M", :date_of_birth=>30.years.ago, 
     :branch_id=>Branch.create(:name=>"alex_#{Time.now.to_i}", :city_id=>City.create(:name=>"alex_#{Time.now.to_i}").id, :address=>"alex and ria").id,
     :activity_categories=>[ActivityCategory.create(:name=>"activity_#{Time.now.to_i}", :front_photo_id=>"123", :short_description=>"short_description")],
     :mobile=>"0123456789", 
     :university=>"alex",
     :post_updates_to_facebook=>false}
  end
  
  describe "GET edit" do
    it "assigns the requested volunteer as @volunteer" do
      login_user(request, @user)
      volunteer = Volunteer.create! valid_attributes
      get :edit, :id => volunteer.id.to_s
      assigns(:volunteer).should eq(volunteer)
    end
  end
  
  describe "PUT update" do
    describe "with valid params" do
      it "assigns the requested volunteer as @volunteer" do
        login_user(request, @user)
        volunteer = Volunteer.create! valid_attributes
        put :update, :id => volunteer.id
        assigns(:volunteer).should eq(volunteer)
      end
    end

    describe "with invalid params" do
      it "assigns the volunteer as @volunteer" do
        login_user(request, @user)
        volunteer = Volunteer.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Volunteer.any_instance.stub(:save).and_return(false)
        put :update, :id => volunteer.id.to_s, :volunteer => {}
        assigns(:volunteer).should eq(volunteer)
      end
    end
  end
end