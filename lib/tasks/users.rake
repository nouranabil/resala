namespace :users do
  desc "Make user an admin"
  task(:make_admin => :environment) do
    name = ENV['name']
    unless name
      puts "Name can't be blank!"
    else
      unless user = User.find_by_name(name)
        puts "Name '#{name}' doesn't exist!"
      else
        user.type = 'Admin'
        user.save
        puts "User '#{name}' is now an admin."
      end
    end
  end
  
  desc "Make user a facebook page admin"
  task(:make_facebook_admin => :environment) do
    name = ENV['name']
    unless name
      puts "Name can't be blank!"
    else
      unless user = User.find_by_name(name)
        puts "Name '#{name}' doesn't exist!"
      else
        user.update_attributes :facebook_page_admin => '1'
        puts "User '#{name}' is now an admin."
      end
    end
  end
end