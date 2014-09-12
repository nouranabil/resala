class AddUniqueIndexOnVolunteerUid < ActiveRecord::Migration
  def self.up
    add_index(:users, [:type, :uid, :provider], :unique => true, :name => 'by_uid_type_provider')
  end

  def self.down
    remove_index :users, :name => :by_uid_type_provider
  end
end
