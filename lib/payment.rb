module Payment
  
  def self.get_secure_key
    setting = PaymentSettings.find_by_key(Rails.env);
    decrypted_value = Encryptor.decrypt(setting.secure_key, :key => setting.secure_key_key) if setting
    return decrypted_value
  end
  
  Payment::RESPONSES = {
  "0"=> "Transaction Successful",
  "?"=> "Transaction status is unknown",
  "1"=> "Unknown Error",
  "2"=> "Bank Declined Transaction",
  "3"=> "No Reply from Bank",
  "4"=> "Expired Card",
  "5"=> "Insufficient funds",
  "6"=> "Error Communicating with Bank",
  "7"=> "Payment Server System Error",
  "8"=> "Transaction Type Not Supported",
  "9"=> "Bank declined transaction (Do not contact Bank)",
  "A"=> "Transaction Aborted",
  "C"=> "Transaction Cancelled",
  "D"=> "Deferred transaction has been received and is awaiting processing",
  "F"=> "3D Secure Authentication failed",
  "I"=> "Card Security Code verification failed",
  "L"=> "Shopping Transaction Locked (Please try the transaction again later)",
  "N"=> "Cardholder is not enrolled in Authentication scheme",
  "P"=> "Transaction has been received by the Payment Adaptor and is being processed",
  "R"=> "Transaction was not processed - Reached limit of retry attempts allowed",
  "S"=> "Duplicate SessionID (OrderInfo)",
  "T"=> "Address Verification Failed",
  "U"=> "Card Security Code Failed",
  "V"=> "Address Verification and Card Security Code Failed",
  }
  
  # params : the request parameters hash
  # params_to_delete : an array of strings, any additional params other than :controller and a:action
  # that should not be sent with the payment request 
  # return_url: the url to return to after transaction was processed. It can be passed to the method or 
  # specified in params["vpc_ReturnURL"] and neglected from method parameters
  def self.create_url(params,return_url = "")
    # add the start of the vpcURL querystring parameters
    # Remove the Virtual Payment Client URL from the parameter hash as we 
    # do not want to send these fields to the Virtual Payment Client.
    vpc_url = "#{params.delete(:virtualPaymentClientURL)}?"
    params.delete(:controller)
    params.delete(:action)
    if !params[:vpc_ReturnURL]
      params[:vpc_ReturnURL] = return_url
    end
    
    md5_hash_data = get_secure_key;
    
    keys = params.keys.sort
    first_param = true
    keys.each do |key|
      value = params[key]
      # create the md5 input and URL leaving out any fields that have no value
      if value!= ""
        # this ensures the first paramter of the URL is preceded by the '?' char
        vpc_url << (first_param ? (first_param = false; "#{CGI::escape(key.to_s)}=#{CGI::escape(value)}") : "&#{CGI::escape(key.to_s)}=#{CGI::escape(value)}")
        md5_hash_data << value;  
      end
    end
    
    # Create the secure hash and append it to the Virtual Payment Client Data if
    # the merchant secret has been provided.
    if (get_secure_key && get_secure_key != "") 
      vpc_url << "&vpc_SecureHash=#{Digest::MD5::hexdigest(md5_hash_data).upcase}";
    end
    
    return vpc_url
  end
  
  def self.verify_response(params)
    params.delete(:controller)
    params.delete(:action)
    vpc_txn_secure_hash = params.delete("vpc_SecureHash")
    
    secure_secret = get_secure_key
    if secure_secret && secure_secret!="" && params["vpc_TxnResponseCode"]!= 7 && 
      params["vpc_TxnResponseCode"]!= "No Value Returned"
      
      md5_hash_data = secure_secret
      
      keys = params.keys.sort
      keys.each do |key|
        value = params[key]
        # create the md5 hash leaving out the fields with no vlaue
        if(value!="")
          md5_hash_data << value
        end
      end
      
      if (vpc_txn_secure_hash || '').upcase == Digest::MD5::hexdigest(md5_hash_data).upcase 
        return true 
      end
    end
    return false
  end
  
end