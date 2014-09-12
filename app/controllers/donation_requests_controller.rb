class DonationRequestsController < ApplicationController
  before_filter :prepare_lists, :only => [:new, :create]
  
  def new
    @donation_request = DonationRequest.new
  end
  
  def create
    @donation_request = DonationRequest.new(params[:donation_request])
    @donation_request.activity_categories = ActivityCategory.where(:id=>params[:activity_categories]).select('id')
    
    if @donation_request.save
      set_cookie("notice", t("messages.saved", :name=>t("donation_request.donation_request"))) 
      redirect_to(root_path)
    else
      render :action => "new"
    end
  end
  
  #######
  private
  #######
  
  def prepare_lists
    @cities = City.all
    @activity_categories = ActivityCategory.donatable.select("name, id")
  end
end
