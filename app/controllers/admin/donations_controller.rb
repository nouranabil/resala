class Admin::DonationsController < Admin::AdminController
  helper_method :sort_column, :sort_direction
  
  def show
    @donation = DonationRequest.find(params[:id])
  end
  
  def index
    @from_date = Date.strptime("#{params[:from_date][:year]}-#{params[:from_date][:month]}-#{params[:from_date][:day]}") if params[:from_date] && params[:from_date].keys.all?{|k| !params[:from_date][k].blank?}
    @to_date   = Date.strptime("#{params[:to_date][:year]  }-#{params[:to_date][:month]  }-#{params[:to_date][:day]  }") if params[:to_date]   && params[:to_date].keys.all?  {|k| !params[:to_date][k].blank?}
    @donations = Donation.verified.order(sort_column + ' ' + sort_direction)
    @donations = @donations.where('created_at >= ?', @from_date) if @from_date 
    @donations = @donations.where('created_at <= ?', @to_date + 1.day) if @to_date
    @donations = @donations.paginate(:page => params[:page], :per_page=>Donation.per_page).all
  end
  
  #######
  private
  #######
    
  def sort_column
    Donation.column_names.include?(params[:sort]) ? params[:sort] : "created_at"
  end  
    
  def sort_direction
    %w[asc desc].include?(params[:direction]) ?  params[:direction] : "desc"
  end 
end
