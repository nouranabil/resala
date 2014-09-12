class AddSecureKeyToPaymentSettings < ActiveRecord::Migration
  def self.up
    add_column :payment_settings, :secure_key, :string
    add_column :payment_settings, :secure_key_key, :string
  end

  def self.down
    remove_column :payment_settings, :secure_key
    remove_column :payment_settings, :secure_key_key
  end
end
