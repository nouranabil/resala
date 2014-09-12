class ExtendActivityDescriptionAndVolunteerSkillsLength < ActiveRecord::Migration
  def self.up
    change_column(:activities, :description, :string , :limit=>2000)
    change_column(:activities, :volunteers_skills, :string , :limit=>2000)
  end

  def self.down
    Activity.all.each do |a| 
      a.description = a.description[0..254]
      a.volunteers_skills = a.volunteers_skills[0..254]
      a.save 
    end
    change_column(:activities, :description, :string , :limit=>255)
    change_column(:activities, :volunteers_skills, :string , :limit=>255)
  end
end
