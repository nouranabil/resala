class AddExceptionForIrregularMobileNumbersToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :irregular_mobile, :boolean, :default => false
    User.reset_column_information
    invalid_mobs = []
    User.all.each do |u|
      if u.mobile && u.mobile =~ /^01[0-9]{9}$/
        u.update_attribute :irregular_mobile, false
      else
        u.update_attribute :irregular_mobile, true
        invalid_mobs << [u.id, u.mobile, "Admin: #{u.admin?}", "Valid: #{u.valid?}"]
      end
    end
    puts invalid_mobs
  end

  def self.down
    remove_column :users, :irregular_mobile
  end
end
