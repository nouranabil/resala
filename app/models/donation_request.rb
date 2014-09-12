# -*- coding: utf-8 -*-
class DonationRequest < ActiveRecord::Base
  validates :name, :presence=>true, :length=>{:maximum=>250}
  validates :address, :presence=>true, :length=>{:maximum=>250}
  validates :phone,  :length=>{:maximum=>12, :minimum=>7, :allow_blank => true},
                     :format=>{:with => /^[0-9٠-٩\s\-\(\)]+$/ , :unless => Proc.new{|d| d.phone.blank?}}
  validates :email, :length=>{:maximum=>250},
                    :format=>{:with => /^[A-Za-z0-9._]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}$/ , :unless => Proc.new{|d| d.email.blank?}}
                    
  validates :email,:phone, :presence => true, :if => Proc.new{|d| d.new_record? }

  validates :city, :presence=>true
  validates :mobile, :presence=>true, :length=>{:maximum=>15, :minimum=>9}, :format=>{:with => /^[0-9٠-٩\s\-\(\)]+$/ , :unless => Proc.new{|d| d.mobile.blank?} }
  validates :amount, :presence=>true, :length=>{:maximum=>10}, :format=>{:with => /^[0-9\.\(\)]+$/ , :unless => Proc.new{|d| d.amount.blank?} }
  validates :amount_period, :presence=>true, :length=>{:maximum=>20}
  validates :notes, :length=>{:maximum=>250}
  
  has_and_belongs_to_many :activity_categories
  belongs_to :city
  
  def self.per_page
    20
  end
end
