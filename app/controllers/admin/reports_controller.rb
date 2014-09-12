class Admin::ReportsController < Admin::AdminController
  def donations
    @from_date = Date.strptime("#{params[:from_date][:year]}-#{params[:from_date][:month]}-#{params[:from_date][:day]}") if params[:from_date] && params[:from_date].keys.all?{|k| !params[:from_date][k].blank?}
    @to_date   = Date.strptime("#{params[:to_date][:year]  }-#{params[:to_date][:month]  }-#{params[:to_date][:day]  }") if params[:to_date]   && params[:to_date].keys.all?  {|k| !params[:to_date][k].blank?}
    @donations = Donation.verified.order(sort_column + ' ' + sort_direction)
    @donations = @donations.where('created_at >= ?', @from_date) if @from_date 
    @donations = @donations.where('created_at <= ?', @to_date + 1.day) if @to_date
    @reporter = Reporter.new "donations","donations"
    @reporter.report_donations @donations
    @reporter.write_file
    send_file @reporter.path
  end
  
   def volunteers
    @email = current_user.email
    Resque.enqueue(ExportVolunteers, params, @email, sort_column, sort_direction)
    render :text => ("The volunteers report will shortly be sent to " + @email)
   end
  
  def donation_requests
    @from_date = Date.strptime("#{params[:from_date][:year]}-#{params[:from_date][:month]}-#{params[:from_date][:day]}") if params[:from_date] && params[:from_date].keys.all?{|k| !params[:from_date][k].blank?}
    @to_date   = Date.strptime("#{params[:to_date][:year]  }-#{params[:to_date][:month]  }-#{params[:to_date][:day]  }") if params[:to_date]   && params[:to_date].keys.all?  {|k| !params[:to_date][k].blank?}
    @donation_requests = DonationRequest.order("created_at desc")
    @donation_requests = @donation_requests.where('created_at >= ?', @from_date) if @from_date 
    @donation_requests = @donation_requests.where('created_at <= ?', @to_date + 1.day) if @to_date
    @reporter = Reporter.new "donation_requests","donation_requests"
    @reporter.report_donation_requests @donation_requests
    @reporter.write_file
    send_file @reporter.path 
  end
  
  
  
  #######
  private
  #######
  
  def sort_column
    Volunteer.column_names.include?(params[:sort]) ? params[:sort] : "created_at"
  end  
    
  def sort_direction
    %w[asc desc].include?(params[:direction]) ?  params[:direction] : "desc"
  end 

  
end
