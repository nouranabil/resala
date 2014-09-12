class FixDataMigration < ActiveRecord::Migration
  def self.up
    Activity.all.each do|ac|
      if(!ac.valid?)
        puts "activity #{ac.id} found invalid : #{ac.errors.inspect}"
        ac.requires_approval = false
        if ac.start_date.blank?
          ac.start_date = ac.created_at
        end
        if ac.branches.blank?
          ac.branches << Branch.first
        end
        ac.save!
        puts "activity #{ac.id} fixed"
      end
    end
    ActivitiesRequest.all.each do |ar|
      puts "activity request #{ar.id} to be updated"
      ar.status = Status.accepted
      puts "updated activity request #{ar.id} successfully" if ar.save
    end
  end

  def self.down
  end
end
