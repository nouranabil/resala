Factory.define :user, :class => User do |u|
  u.provider        "facebook"
  u.sequence(:provider_token){|x| "#{Time.now.to_i}#{x}" }
  u.sequence(:uid){|x| "#{Time.now.to_i}#{x}" }
  u.name            "Mostafa Arafa"
end

Factory.define :admin_user, :parent=> :user do |u|
  u.type           "Admin"
end

Factory.define :volunteer, :parent=> :user do |u|
  u.type            "Volunteer"
  u.email           "mostafa_#{Time.now.to_i}@espace.com.eg"
  u.gender          "M"
  u.date_of_birth   Time.now - 10.years
  #TODO: create using Factory
  #u.branch_id       Branch.create({:name=>"test_new branch_#{Time.now.to_i}", :city=>City.create(:name=>"city_#{Time.now.to_i}"), :address=>"address"}).id
  u.mobile          "0123456789"
  u.graduated       true
  u.profession      "any profession"
end

Factory.define :volunteer_can_create_activity, :parent=> :volunteer do |u|
  u.type           "Volunteer"
  u.activities_authority_status     "2"
end