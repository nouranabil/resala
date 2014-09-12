require 'spec_helper'

describe AchievementsType do
  it "should be invalid without name" do
    AchievementsType.validate(:name).should have(1).errors_on(:name)
  end
end
