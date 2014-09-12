require 'spec_helper'

describe Admin::AchievementsTypesController do
  before(:all) do
    @user = Factory(:admin_user)
  end

  def valid_attributes
    {:name=>"achievements_type#{Time.now.to_i}"}
  end

  describe "GET index" do
    it "assigns all achievements_types as @achievements_types" do
      login_user(request, @user)
      achievements_types = AchievementsType.create! valid_attributes
      get :index
      assigns(:achievements_types).should_not be(nil)
    end
  end

  describe "GET new" do
    it "assigns a new achievements_type as @achievements_type" do
      login_user(request, @user)
      get :new
      assigns(:achievements_type).should be_a_new(AchievementsType)
    end
  end

  describe "GET edit" do
    it "assigns the requested achievements_type as @achievements_type" do
      login_user(request, @user)
      achievements_type = AchievementsType.create! valid_attributes
      get :edit, :id => achievements_type.id.to_s
      assigns(:achievements_type).should eq(achievements_type)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new achievements_type" do
        login_user(request, @user)
        expect {
          post :create, :achievements_type => valid_attributes
        }.to change(AchievementsType, :count).by(1)
      end

      it "assigns a newly created achievements_type as @achievements_type" do
        login_user(request, @user)
        post :create, :achievements_type => valid_attributes
        assigns(:achievements_type).should be_a(AchievementsType)
        assigns(:achievements_type).should be_persisted
      end

      it "redirects to the created achievements_type" do
        login_user(request, @user)
        post :create, :achievements_type => valid_attributes
        response.should redirect_to(admin_achievements_types_path)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved achievements_type as @achievements_type" do
        login_user(request, @user)
        # Trigger the behavior that occurs when invalid params are submitted
        AchievementsType.any_instance.stub(:save).and_return(false)
        post :create, :achievements_type => {}
        assigns(:achievements_type).should be_a_new(AchievementsType)
      end

      it "re-renders the 'new' template" do
        login_user(request, @user)
        AchievementsType.any_instance.stub(:save).and_return(false)
        post :create, :achievements_type => {}
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested achievements_type" do
        login_user(request, @user)
        achievements_type = AchievementsType.create! valid_attributes
        AchievementsType.any_instance.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => achievements_type.id, :achievements_type => {'these' => 'params'}
      end

      it "assigns the requested achievements_type as @achievements_type" do
        login_user(request, @user)
        achievements_type = AchievementsType.create! valid_attributes
        put :update, :id => achievements_type.id, :achievements_type => valid_attributes
        assigns(:achievements_type).should eq(achievements_type)
      end

      it "redirects to the achievements_type" do
        login_user(request, @user)
        achievements_type = AchievementsType.create! valid_attributes
        put :update, :id => achievements_type.id, :achievements_type => valid_attributes
        response.should redirect_to(admin_achievements_types_path)
      end
    end

    describe "with invalid params" do
      it "assigns the achievements_type as @achievements_type" do
        login_user(request, @user)
        achievements_type = AchievementsType.create! valid_attributes
        AchievementsType.any_instance.stub(:save).and_return(false)
        put :update, :id => achievements_type.id.to_s, :achievements_type => {}
        assigns(:achievements_type).should eq(achievements_type)
      end

      it "re-renders the 'edit' template" do
        login_user(request, @user)
        achievements_type = AchievementsType.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        AchievementsType.any_instance.stub(:save).and_return(false)
        put :update, :id => achievements_type.id.to_s, :achievements_type => {}
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested achievements_type" do
      login_user(request, @user)
      achievements_type = AchievementsType.create! valid_attributes
      expect {
        delete :destroy, :id => achievements_type.id.to_s
      }.to change(AchievementsType, :count).by(-1)
    end

    it "redirects to the achievements_type list" do
      login_user(request, @user)
      achievements_type = AchievementsType.create! valid_attributes
      delete :destroy, :id => achievements_type.id.to_s
      response.should redirect_to(admin_achievements_types_path)
    end
  end
end