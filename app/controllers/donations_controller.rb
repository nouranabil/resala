class DonationsController < ApplicationController

  def new
    @donation = Donation.new
  end
  
  def create
    #create and verify donation
    @donation = Donation.new(params[:donation])
    
    if @donation.valid?
      options = Donation.settings
      #fill the transaction specific data and redirect to payment server
      options[:vpc_Amount]= (@donation.amount * 100).to_s
      options[:vpc_MerchTxnRef] = "resala_donation_#{Time.now.utc}" #required : A unique value created by the merchant. a reference key to the Payment Server database to obtain a copy of lost/missing receipts
      #options[:vpc_OrderInfo]  = params[:donation].to_param #Optional : The merchant's identifier used to identify the order on the Payment Server.
      #options[:vpc_TicketNo] = 'wakwak' #Optional : Extra transaction data that is passed with the Transaction Request and stored on the Payment Server.
      session[:donation_params] = params[:donation]
      url = Payment.create_url(options,url_for(:controller=>:donations,:action=>:handle_response))
      redirect_to(url)
    else
      render :action => "new"
    end
    
  end
  
  def handle_response
    if Payment.verify_response(params)
      #@donation = Donation.find_by_id(params[:vpc_OrderInfo]);
      if(params[:vpc_TxnResponseCode] == '0')
        @donation = Donation.new(session[:donation_params])
        @donation.verify!
        @donation.save
      else
        @error_code = params["vpc_TxnResponseCode"]
        @error_message = params["vpc_Message"]
      end
    else
      @error_code = params["vpc_TxnResponseCode"]
      @error_message = Payment::RESPONSES[params["vpc_TxnResponseCode"]]
    end
    session[:donation_params] = nil
    
    msg = ""
    if @donation && @donation.verified?
      msg = t("messages.donation_done", :amount=>@donation.amount)
      if @donation.activity_category
        msg += " " +  t("messages.donation_done_for_category", :activity=>@donation.activity_category.name)
      end  
      set_cookie("notice", msg)
    else
      set_cookie("alert", t('messages.donation_error'))
    end
    redirect_to page_path(:how_to_donate)
  end
  
end
