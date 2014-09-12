class CreateVolunteers < ActiveRecord::Migration
  def self.up
    add_column :users, :email, :string
    add_column :users, :gender, :string
    add_column :users, :date_of_birth, :date
    add_column :users, :post_updates_to_facebook, :boolean, :default=>true
    add_column :users, :branch_id, :integer
    add_column :users, :mobile, :string
    add_column :users, :graduated, :boolean  
    add_column :users, :profession, :string
    add_column :users, :company, :string
    add_column :users, :university, :string
    add_column :users, :school_year, :string
    add_column :users, :blood_donation, :boolean, :default=>false
    add_column :users, :blood_type, :string
    add_column :users, :bio, :text
    add_column :users, :get_activities_updates, :boolean, :default=>false
    add_column :users, :days_to_confirm, :string
    add_column :users, :available_days, :integer, :default=>0
  end

  def self.down
    remove_column :users, :email
    remove_column :users, :gender
    remove_column :users, :date_of_birth
    remove_column :users, :post_updates_to_facebook
    remove_column :users, :branch_id
    remove_column :users, :mobile
    remove_column :users, :graduated  
    remove_column :users, :profession
    remove_column :users, :company
    remove_column :users, :university
    remove_column :users, :school_year
    remove_column :users, :blood_donation
    remove_column :users, :blood_type
    remove_column :users, :bio
    remove_column :users, :get_activities_updates
    remove_column :users, :days_to_confirm
    remove_column :users, :available_days
  end
end
