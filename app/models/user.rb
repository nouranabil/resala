# -*- coding: utf-8 -*-
class User < ActiveRecord::Base
  validates :provider, :presence=>true, :length=>{:maximum=>250}
  validates :uid, :presence=>true, :uniqueness=>{:scope => [:provider, :type]}, :length=>{:maximum=>250}
  validates :name, :presence=>true, :length=>{:maximum=>250}
  validates :existing_role, :length=>{:maximum=>250}
  validates :provider_token, :presence=>true, :length=>{:maximum=>250}
  
  with_options :if => Proc.new{|u| u.type.present? } do |user|
    user.validates :email, :presence=>true, :length=>{:maximum=>250}, :format=>{:with => /^[A-Za-z0-9._]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}$/ , :unless => Proc.new{|e| e.email.blank?} }
    user.validates :mobile, :format=>{:with => /^[0-9٠-٩\s\-\(\)]+$/ , :unless => Proc.new{|d| d.mobile.blank?} }, :if => Proc.new{|u| u.irregular_mobile }
    user.validates :mobile, :length=>{:maximum=>15, :minimum=>9}, :unless=>Proc.new{|v| v.mobile.blank?}, :if => Proc.new{|u| u.irregular_mobile }
    user.validates :mobile, :presence=>true, :format=>{:with => /^01[0-9]{9}$/, :unless => Proc.new{|d| d.mobile.blank? || d.irregular_mobile }}, :unless => Proc.new{|u| u.irregular_mobile }
  end
    
  has_many :activities
  
  scope :active, where(:suspended => false)
  scope :latest, order("created_at desc")
  scope :emailable, where(:suspended => false, :get_activities_updates=> true)
  
  def self.per_page
    20
  end
  
  def admin?
    type == "Admin"
  end
  
  def self.create_admin_with_omniauth(auth)
    User.find_by_type_and_provider_and_uid(nil, auth["provider"], auth["uid"]) || create!(self.basic_attrs(auth))
  end
  
  def self.basic_attrs(auth)
    return {:provider => auth["provider"],
            :uid => auth["uid"],
            :name => auth["user_info"]["name"],
            :image => auth["user_info"]["image"],
            :provider_token => auth["credentials"]["token"],
            :provider_secret => auth["credentials"]["secret"]}
  end
  
  def set_gender=(gen)
    self.gender = nil
    self.gender = "M" if gen && gen.downcase == "male"
    self.gender = "F" if gen && gen.downcase == "female"
  end
  
  def gender_name
    return I18n.t("messages.#{gender.downcase}")
  end
end
