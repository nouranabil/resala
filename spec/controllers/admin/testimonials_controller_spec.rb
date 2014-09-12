require 'spec_helper'

describe Admin::TestimonialsController do
  before(:all) do
    @user = Factory(:admin_user)
  end
  
  def valid_attributes
    {:title=>"new testimonial_#{Time.now.to_i}",
      :source=>"source",
      :disclosure_date=>Time.now}
  end

  describe "GET index" do
    it "assigns all testimonials as @testimonials" do
      login_user(request, @user)
      testimonial = Testimonial.create! valid_attributes
      get :index
      assigns(:testimonials).should eq([testimonial])
    end
  end

  describe "GET show" do
    it "assigns the requested testimonial as @testimonial" do
      login_user(request, @user)
      testimonial = Testimonial.create! valid_attributes
      get :show, :id => testimonial.id.to_s
      assigns(:testimonial).should eq(testimonial)
    end
  end

  describe "GET new" do
    it "assigns a new testimonial as @testimonial" do
      login_user(request, @user)
      get :new
      assigns(:testimonial).should be_a_new(Testimonial)
    end
  end

  describe "GET edit" do
    it "assigns the requested testimonial as @testimonial" do
      login_user(request, @user)
      testimonial = Testimonial.create! valid_attributes
      get :edit, :id => testimonial.id.to_s
      assigns(:testimonial).should eq(testimonial)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new Testimonial" do
        login_user(request, @user)
        expect {
          post :create, :testimonial => valid_attributes
        }.to change(Testimonial, :count).by(1)
      end

      it "assigns a newly created testimonial as @testimonial" do
        login_user(request, @user)
        post :create, :testimonial => valid_attributes
        assigns(:testimonial).should be_a(Testimonial)
        assigns(:testimonial).should be_persisted
      end

      it "redirects to the created testimonial" do
        login_user(request, @user)
        post :create, :testimonial => valid_attributes
        response.should redirect_to(admin_testimonial_path(Testimonial.last))
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved testimonial as @testimonial" do
        login_user(request, @user)
        # Trigger the behavior that occurs when invalid params are submitted
        Testimonial.any_instance.stub(:save).and_return(false)
        post :create, :testimonial => {}
        assigns(:testimonial).should be_a_new(Testimonial)
      end

      it "re-renders the 'new' template" do
        login_user(request, @user)
        # Trigger the behavior that occurs when invalid params are submitted
        Testimonial.any_instance.stub(:save).and_return(false)
        post :create, :testimonial => {}
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested testimonial" do
        login_user(request, @user)
        testimonial = Testimonial.create! valid_attributes
        # Assuming there are no other testimonials in the database, this
        # specifies that the Testimonial created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        Testimonial.any_instance.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => testimonial.id, :testimonial => {'these' => 'params'}
      end

      it "assigns the requested testimonial as @testimonial" do
        login_user(request, @user)
        testimonial = Testimonial.create! valid_attributes
        put :update, :id => testimonial.id, :testimonial => valid_attributes
        assigns(:testimonial).should eq(testimonial)
      end

      it "redirects to the testimonial" do
        login_user(request, @user)
        testimonial = Testimonial.create! valid_attributes
        put :update, :id => testimonial.id, :testimonial => valid_attributes
        response.should redirect_to(admin_testimonial_path(testimonial)+"?page=1")
      end
    end

    describe "with invalid params" do
      it "assigns the testimonial as @testimonial" do
        login_user(request, @user)
        testimonial = Testimonial.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Testimonial.any_instance.stub(:save).and_return(false)
        put :update, :id => testimonial.id.to_s, :testimonial => {}
        assigns(:testimonial).should eq(testimonial)
      end

      it "re-renders the 'edit' template" do
        login_user(request, @user)
        testimonial = Testimonial.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Testimonial.any_instance.stub(:save).and_return(false)
        put :update, :id => testimonial.id.to_s, :testimonial => {}
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested testimonial" do
      login_user(request, @user)
      testimonial = Testimonial.create! valid_attributes
      expect {
        delete :destroy, :id => testimonial.id.to_s
      }.to change(Testimonial, :count).by(-1)
    end

    it "redirects to the testimonials list" do
      login_user(request, @user)
      testimonial = Testimonial.create! valid_attributes
      delete :destroy, :id => testimonial.id.to_s
      response.should redirect_to(admin_testimonials_url+"?page=1")
    end
  end

end
