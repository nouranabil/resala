class CreateActivities < ActiveRecord::Migration
  def self.up
    create_table :activities do |t|
      t.string          :title
      t.string          :description
      t.datetime        :start_date
      t.string          :duration
      t.string          :location
      t.integer         :required_volunteers_count
      t.string          :volunteers_skills
      t.boolean         :facebook_announce
      t.boolean         :email_notifications
      t.boolean         :disclose_volunteers
      t.integer         :user_id
      t.boolean         :published, :default=>false
      
      t.timestamps
    end
  end

  def self.down
    drop_table :activities
  end
end
