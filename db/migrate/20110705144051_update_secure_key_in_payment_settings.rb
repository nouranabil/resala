class UpdateSecureKeyInPaymentSettings < ActiveRecord::Migration
  def self.up
    remove_column :payment_settings, :secure_key
    add_column :payment_settings, :secure_key, :binary
  end

  def self.down
    remove_column :payment_settings, :secure_key
    add_column :payment_settings, :secure_key, :string
  end
end
