require 'spec_helper'

describe Achievement do
  it "should be invalid without amount" do
    Achievement.validate(:amount).should have(1).errors_on(:amount)
  end
  it "should be invalid without activity" do
    Achievement.validate(:activity_id).should have(1).errors_on(:activity_id)
  end
  it "should be invalid without achievements type" do
    Achievement.validate(:achievements_type_id).should have(1).errors_on(:achievements_type_id)
  end
end