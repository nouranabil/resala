class CreatePaymentSettings < ActiveRecord::Migration
  def self.up
    create_table :payment_settings do |t|
      t.string :key, :null=> false
      t.string :virtualPaymentClientURL, :null=> false
      t.string :vpc_AccessCode, :null=> false #required : Authenticates the merchant on the Payment Server
      t.string :vpc_Merchant, :null=> false   #required : The unique Merchant Id assigned to a merchant by the Payment Provider.
      t.string :vpc_Locale, :default=> 'ar', :null=> false
    end
  end

  def self.down
    drop_table :payment_settings
  end
end
