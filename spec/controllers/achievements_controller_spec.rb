require 'spec_helper'
describe AchievementsController do

  # This should return the minimal set of attributes required to create a valid
  # Achievement. As you add validations to Achievement, be sure to
  # update the return value of this method accordingly.
  def valid_attributes
    {}
  end
  before :all do
    @user = Factory(:volunteer_can_create_activity)
    @activity = Factory(:activity)
    @activity.status = 2
    @activity.user = @user
    @activity.save
  end

  describe "GET new" do
    it "assigns a new achievement as @achievement" do
      # get new_volunteer_activity_achievement_path(@activity.user, @activity)
      # assigns(:achievements).should_not be(nil)
    end
  end

  

end
