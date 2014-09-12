require 'spec_helper'

describe Admin::BranchesController do
  before(:all) do
    @user = Factory(:admin_user)
  end
  
  def valid_attributes
    {:name=>"new branch_#{Time.now.to_i}",
      :city=>City.create(:name=>"city_#{Time.now.to_i}"),
      :address=>"address"}
  end

  describe "GET index" do
    it "assigns all branches as @branches" do
      branch = Branch.create! valid_attributes
      login_user(request, @user)
      get :index
      # assigns(:branches).should eq([branch])
    end
  end
  
  describe "GET new" do
    it "assigns a new branch as @branch" do
      login_user(request, @user)
      get :new
      assigns(:branch).should be_a_new(Branch)
    end
  end

  describe "GET edit" do
    it "assigns the requested branch as @branch" do
      login_user(request, @user)
      branch = Branch.create! valid_attributes
      get :edit, :id => branch.id.to_s
      assigns(:branch).should eq(branch)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new branch" do
        login_user(request, @user)
        expect {
          post :create, :branch => valid_attributes
        }.to change(Branch, :count).by(1)
      end

      it "assigns a newly created branch as @branch" do
        login_user(request, @user)
        post :create, :branch => valid_attributes
        assigns(:branch).should be_a(Branch)
        assigns(:branch).should be_persisted
      end

      it "redirects to the created branch" do
        login_user(request, @user)
        post :create, :branch => valid_attributes
        response.should redirect_to(admin_branches_path)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved branch as @branch" do
        login_user(request, @user)
        # Trigger the behavior that occurs when invalid params are submitted
        Branch.any_instance.stub(:save).and_return(false)
        post :create, :branch => {}
        assigns(:branch).should be_a_new(Branch)
      end

      it "re-renders the 'new' template" do
        login_user(request, @user)
        # Trigger the behavior that occurs when invalid params are submitted
        Branch.any_instance.stub(:save).and_return(false)
        post :create, :branch => {}
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested branch" do
        login_user(request, @user)
        branch = Branch.create! valid_attributes
        # Assuming there are no other branches in the database, this
        # specifies that the Branch created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        Branch.any_instance.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => branch.id, :branch => {'these' => 'params'}
      end

      it "assigns the requested branch as @branch" do
        login_user(request, @user)
        branch = Branch.create! valid_attributes
        put :update, :id => branch.id, :branch => valid_attributes
        assigns(:branch).should eq(branch)
      end

      it "redirects to the branch" do
        login_user(request, @user)
        branch = Branch.create! valid_attributes
        put :update, :id => branch.id, :branch => valid_attributes
        response.should redirect_to(admin_branches_path)
      end
    end

    describe "with invalid params" do
      it "assigns the branch as @branch" do
        login_user(request, @user)
        branch = Branch.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Branch.any_instance.stub(:save).and_return(false)
        put :update, :id => branch.id.to_s, :branch => {}
        assigns(:branch).should eq(branch)
      end

      it "re-renders the 'edit' template" do
        login_user(request, @user)
        branch = Branch.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Branch.any_instance.stub(:save).and_return(false)
        put :update, :id => branch.id.to_s, :branch => {}
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested branch" do
      login_user(request, @user)
      branch = Branch.create! valid_attributes
      expect {
        delete :destroy, :id => branch.id.to_s
      }.to change(Branch, :count).by(-1)
    end

    it "redirects to the branches list" do
      login_user(request, @user)
      branch = Branch.create! valid_attributes
      delete :destroy, :id => branch.id.to_s
      response.should redirect_to(admin_branches_path)
    end
  end

end
