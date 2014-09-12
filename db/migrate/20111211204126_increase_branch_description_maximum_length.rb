class IncreaseBranchDescriptionMaximumLength < ActiveRecord::Migration
  def self.up
    change_column :branches, :description, :string , :limit=>2000
  end

  def self.down
    Branch.all.each do |branch| 
      branch.description = branch.description[0..254]
      branch.save 
    end
    change_column(:branches, :description, :string , :limit=>255)
  end
end
