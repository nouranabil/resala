class IncreaseActivityDescriptionMaximumLength < ActiveRecord::Migration
  def self.up
    change_column(:activities, :description, :string , :limit=>5000)
  end

  def self.down
    Activity.all.each do |a| 
      if a.description.length > 2000 
        a.description = a.description[0..2000]
        a.save 
      end
    end
    change_column(:activities, :description, :string , :limit=>2000)
  end
end
