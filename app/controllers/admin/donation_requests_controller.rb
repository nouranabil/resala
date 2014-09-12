class Admin::DonationRequestsController < Admin::AdminController
  
  def show
    @donation_request = DonationRequest.find(params[:id])
  end
  
  def index
    @from_date = Date.strptime("#{params[:from_date][:year]}-#{params[:from_date][:month]}-#{params[:from_date][:day]}") if params[:from_date] && params[:from_date].keys.all?{|k| !params[:from_date][k].blank?}
    @to_date   = Date.strptime("#{params[:to_date][:year]  }-#{params[:to_date][:month]  }-#{params[:to_date][:day]  }") if params[:to_date]   && params[:to_date].keys.all?  {|k| !params[:to_date][k].blank?}
    @donation_requests = DonationRequest.order("created_at desc")
    @donation_requests = @donation_requests.where('created_at >= ?', @from_date) if @from_date 
    @donation_requests = @donation_requests.where('created_at <= ?', @to_date + 1.day) if @to_date
    @donation_requests = @donation_requests.paginate(:page => params[:page], :per_page=>DonationRequest.per_page).all
  end
  
  def update
    @donation_request = DonationRequest.find(params[:id])
    params[:page] || 1 
    
    if @donation_request.update_attribute(:reviewed, params[:reviewed])
      redirect_to admin_donation_requests_path(:page=>params[:page]), :notice => t("messages.generic_updated")
    else
      redirect_to admin_donation_requests_path(:page=>params[:page]), :alert => t("messages.failed")
    end    
  end
  
  def destroy
    @donation_request = DonationRequest.find(params[:id])
    @donation_request.destroy
    params[:page] ||= 1
    redirect_to admin_donation_requests_path(:page=>params[:page]), :notice => t("messages.deleted")
  end
end
