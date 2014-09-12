namespace :payment do
  desc "Insert Payment data"
  task(:update_data => :environment) do
    puts "## Updating #{Rails.env} payment setting .. .. .."
    
    unless (ENV['secure_key']) 
      puts "## Not Valid! , Please send me the secure_key"
      return false
    end
    
    secure_key_key = Digest::SHA256.hexdigest(rand.to_s[2..9].to_s)
    encrypted_secure_key = Encryptor.encrypt(ENV['secure_key'], :key => secure_key_key) 
    
    payment_settings = PaymentSettings.find_or_initialize_by_key(Rails.env)
    payment_settings.update_attributes({:virtualPaymentClientURL=>PAYMENT_CONFIG[:virtualPaymentClientURL],
                                        :vpc_AccessCode=>PAYMENT_CONFIG[:vpc_AccessCode],
                                        :vpc_Merchant=>PAYMENT_CONFIG[:vpc_Merchant], 
                                        :secure_key=>encrypted_secure_key, 
                                        :secure_key_key=>secure_key_key})
                                        
    puts "## #{Rails.env} payment setting has been updated"
  end
end