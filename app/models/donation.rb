# -*- coding: utf-8 -*-
class Donation < ActiveRecord::Base
  STATUS = ['new','verified', 'reviewed']
  validates :donator_name, :length=>{:maximum=>250}
  validates :amount, :numericality => { :only_integer => true }, :if => Proc.new { |donation| !donation.amount.blank? }
  validates :amount, :presence=>true
  validates :phone,  :length=>{:maximum=>12, :minimum=>7, :allow_blank => true}, :format=>{:with => /^[0-9٠-٩\s\-\(\)]+$/ , :unless => Proc.new{|d| d.phone.blank?}}
  validates :email,  :length=>{:maximum=>250}, :format=>{:with => /^[A-Za-z0-9._]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}$/ , :unless => Proc.new{|d| d.email.blank?}}
  belongs_to :activity_category
  scope :verified, where("status <> 0")
  
  def self.per_page
    20
  end
  
  def self.settings
    settings = {}
    PaymentSettings::KEYS.each do |key|
      s = PaymentSettings.find_by_key(Rails.env)
      settings[key] = s[key] if s
    end
    return settings.merge({:vpc_Version => '1', :vpc_Command => 'pay'})
  end
  
  def verify!
    if !self.new_record?
      self.update_attribute(:status,1)
    else
      self.status = 1
    end 
  end
  
  def verified?
    self.status != 0
  end
  
  def status_message
    STATUS[self[:status]]
  end
end
